import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_image/flutter_image.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nelo/models/manga.dart';
import 'package:nelo/screens/manga_page.dart';
import 'package:nelo/services/api.dart';
import 'package:nelo/services/database.dart';
import 'package:transparent_image/transparent_image.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Manga>? animes;

  @override
  void initState() {
    _getBookmark();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Favorites',
          style: GoogleFonts.raleway(),
        ),
      ),
      body: FutureBuilder(
        future: API.getMangaList(sort: ''),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Manga> mangas = snapshot.data as List<Manga>;
          var background = mangas[Random().nextInt(mangas.length)].poster;
          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: NetworkImageWithRetry(background ?? ''),
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: animes == null
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : animes!.isEmpty
                          ? Center(
                              child: Text(
                                'You have no animes in your favorite list.',
                                style: GoogleFonts.raleway(color: Colors.white),
                              ),
                            )
                          : ListView.separated(
                              separatorBuilder: (context, index) => Divider(
                                color: Colors.transparent,
                              ),
                              itemCount: animes!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: EdgeInsets.all(4.0),
                                  height: height * 0.19,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MangaPage(manga: animes![index]),
                                        ),
                                      ).then((value) => _getBookmark());
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        Positioned(
                                          child: Container(
                                            height: height * 0.162,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                    begin: Alignment.topRight,
                                                    end: Alignment.bottomLeft,
                                                    colors: [
                                                      GFColors.INFO,
                                                      Colors.transparent,
                                                    ]),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Row(
                                              children: <Widget>[
                                                SizedBox(
                                                  width: height * 0.162 + 16,
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 8.0,
                                                        horizontal: 16),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          animes![index]
                                                                  .title ??
                                                              '',
                                                          // overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts.raleway(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.04),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 16,
                                          top: 0,
                                          child: Container(
                                            height: height * 0.19,
                                            alignment: Alignment.centerRight,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: FadeInImage(
                                                placeholder: MemoryImage(
                                                    kTransparentImage),
                                                image: NetworkImageWithRetry(
                                                    animes![index].poster ??
                                                        ''),
                                                width: height * 0.16,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  _getBookmark() async {
    var bm = await BookmarkHandler().getBookmarks();
    setState(() => animes = bm);
  }
}
