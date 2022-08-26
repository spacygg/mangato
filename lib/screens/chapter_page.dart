// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:nelo/models/chapter.dart';
import 'package:nelo/models/manga.dart';
import 'package:nelo/services/api.dart';
import 'package:nelo/services/database.dart';
import 'package:startapp_sdk/startapp.dart';
import 'package:transparent_image/transparent_image.dart';

class ChapterPage extends StatefulWidget {
  Manga manga;
  List<String?> images;
  List<Chapter> chapters;
  int index;
  ChapterPage(
      {Key? key,
      required this.manga,
      required this.images,
      required this.chapters,
      required this.index})
      : super(key: key);

  @override
  _ChapterPageState createState() => _ChapterPageState();
}

class _ChapterPageState extends State<ChapterPage> {
  var startAppSdk = StartAppSdk();
  StartAppInterstitialAd? interstitialAd;

  void loadInterstitialAd() {
    startAppSdk.loadInterstitialAd().then((interstitialAd) {
      interstitialAd = interstitialAd;
      interstitialAd.show();
    }).onError<StartAppException>((ex, stackTrace) {
      debugPrint("Error loading Interstitial ad: ${ex.message}");
    }).onError((error, stackTrace) {
      debugPrint("Error loading Interstitial ad: $error");
    });
  }

  @override
  void initState() {
    BookmarkHandler().insertEp(widget.chapters[widget.index]);
    loadInterstitialAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: FadeInImage(
            placeholder: MemoryImage(kTransparentImage),
            image: NetworkImageWithRetry(widget.manga.poster ?? ''),
            fit: BoxFit.cover,
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 3,
            sigmaY: 3,
          ),
          child: Container(
            color: Colors.black.withOpacity(.8),
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: ListView.builder(
            itemCount: widget.images.length + 2,
            itemBuilder: (context, index) => index == 0
                ? Container(
                    height: MediaQuery.of(context).size.height / 5,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: widget.index == widget.chapters.length - 1
                            ? null
                            : () async {
                                // showInterstitial();
                                var images = await API.getChapterImages(
                                    widget.chapters[widget.index + 1].url ??
                                        '');
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChapterPage(
                                        manga: widget.manga,
                                        images: images,
                                        chapters: widget.chapters,
                                        index: widget.index + 1),
                                  ),
                                ).then((value) => setState(() {}));
                              },
                        child: Text('Previous Chapter'),
                      ),
                    ),
                  )
                : index == widget.images.length + 1
                    ? Container(
                        height: MediaQuery.of(context).size.height / 5,
                        child: Center(
                          child: ElevatedButton(
                            onPressed: widget.index == 0
                                ? null
                                : () async {
                                    // showInterstitial();
                                    var images = await API.getChapterImages(
                                        widget.chapters[widget.index - 1].url ??
                                            '');
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChapterPage(
                                            manga: widget.manga,
                                            images: images,
                                            chapters: widget.chapters,
                                            index: widget.index - 1),
                                      ),
                                    ).then((value) => setState(() {}));
                                  },
                            child: Text('Next Chapter'),
                          ),
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        color: Colors.transparent,
                        child: InteractiveViewer(
                          child: CachedNetworkImage(
                            imageUrl: widget.images[index - 1] ?? '',
                            httpHeaders: const {
                              "referer": "https://manganelo.com"
                            },
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) {
                              var height = MediaQuery.of(context).size.height;
                              return SizedBox(
                                height: height / 5,
                                child: Center(
                                    child: CircularProgressIndicator(
                                        value: downloadProgress.progress)),
                              );
                            },
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
          ),
        ),
      ]),
    );
  }
}
