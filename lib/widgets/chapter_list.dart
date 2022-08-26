import 'dart:math';

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:nelo/models/chapter.dart';
import 'package:nelo/models/manga.dart';
import 'package:nelo/screens/chapter_page.dart';
import 'package:nelo/services/api.dart';
import 'package:nelo/services/database.dart';
import 'package:startapp_sdk/startapp.dart';

class ChapterList extends StatefulWidget {
  Manga manga;
  ChapterList({Key? key, required this.manga}) : super(key: key);

  @override
  _ChapterListState createState() => _ChapterListState();
}

class _ChapterListState extends State<ChapterList> {
  int _selectedChip = 0;
  List<Chapter> chunk = [];
  var startAppSdk = StartAppSdk();
  StartAppInterstitialAd? interstitialAd;

  void loadInterstitialAd() {
    startAppSdk.loadInterstitialAd().then((interstitialAd) {
      interstitialAd = interstitialAd;
    }).onError<StartAppException>((ex, stackTrace) {
      debugPrint("Error loading Interstitial ad: ${ex.message}");
    }).onError((error, stackTrace) {
      debugPrint("Error loading Interstitial ad: $error");
    });
  }

  void showInterstitial() {
    if (interstitialAd != null) {
      interstitialAd!.show().then((shown) {
        if (shown) {
          interstitialAd = null;
          loadInterstitialAd();
        }
        return null;
      }).onError((error, stackTrace) {
        debugPrint("Error showing Interstitial ad: $error");
      });
    }
  }

  @override
  void initState() {
    loadInterstitialAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: API.getMangaChapters(widget.manga.url ?? ''),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 100,
              child: Center(
                child: Text('Coming Soon..'),
              ),
            );
          }
          if (!snapshot.hasData) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 100,
              child: Center(
                child: LinearProgressIndicator(),
              ),
            );
          }

          List<Chapter> chapters = snapshot.data as List<Chapter>;

          var last = (_selectedChip * 50) + 50;
          if (chapters.length < last) last = chapters.length;
          chunk = chapters.sublist((_selectedChip * 50), last);

          return Column(
            children: [
              chapters.length > 50
                  ? SizedBox(
                      height: 70,
                      child: ListView.builder(
                        itemCount: (chapters.length / 50).ceil(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FilterChip(
                              onSelected: (selected) {
                                setState(() {
                                  _selectedChip = index;
                                  // _updateChunk(index * 50);
                                });
                              },
                              selected: _selectedChip == index,
                              backgroundColor:
                                  const Color.fromARGB(255, 19, 18, 18)
                                      .withOpacity(.8),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              label: Text(
                                '${chapters.length - index * 50} - ${max(chapters.length - (index + 1) * 50, 1)}',
                              ),
                            ),
                          );
                        },
                        scrollDirection: Axis.horizontal,
                      ),
                    )
                  : const SizedBox(
                      height: 20,
                    ),
              chunk.isNotEmpty
                  ? ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: chunk.length,
                      separatorBuilder: (context, index) => Divider(),
                      itemBuilder: (BuildContext context, int index) {
                        // animationController.forward();
                        return FutureBuilder<bool>(
                            future: BookmarkHandler()
                                .isWatched(episode: chunk[index]),
                            builder: (context, snapshot) {
                              bool alreadyWatched = false;
                              if (snapshot.hasData) {
                                alreadyWatched = snapshot.data as bool;
                              }
                              return GFListTile(
                                onLongPress: () {
                                  BookmarkHandler().deleteEp(chunk[index]);
                                  setState(() {});
                                },
                                onTap: () async {
                                  showInterstitial();
                                  var images = await API
                                      .getChapterImages(chunk[index].url ?? '');
                                  // ignore: use_build_context_synchronously
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChapterPage(
                                        manga: widget.manga,
                                        images: images,
                                        index: _selectedChip * 50 + index,
                                        chapters: chapters,
                                      ),
                                    ),
                                  ).then((value) => setState(() {}));
                                },
                                avatar: Icon(alreadyWatched
                                    ? Icons.check_box_outlined
                                    : Icons.check_box_outline_blank),
                                title: Text(
                                  '${chunk[index].title}',
                                  textAlign: TextAlign.justify,
                                ),
                              );
                            });
                      },
                    )
                  : const Center(
                      child: LinearProgressIndicator(
                        color: Colors.amber,
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}
