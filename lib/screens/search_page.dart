import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_image/flutter_image.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nelo/models/manga.dart';
import 'package:nelo/screens/manga_page.dart';
import 'package:nelo/services/api.dart';
import 'package:transparent_image/transparent_image.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Manga>? mangas;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        // backgroundColor: Colors.white,
        appBar: AppBar(
          title: TextField(
            autofocus: true,
            style: GoogleFonts.raleway(color: Colors.white),
            onChanged: (value) => _search(value),
            decoration: InputDecoration(
              hintText: 'Search for Manga...',
              iconColor: Colors.white,
              hintStyle: GoogleFonts.raleway(
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: mangas == null
            ? Center(
                child: Text('Start typing to search for manga..'),
              )
            : ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: Colors.transparent,
                ),
                itemCount: mangas!.length,
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
                                MangaPage(manga: mangas![index]),
                          ),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Positioned(
                            child: Container(
                              height: height * 0.162,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        GFColors.INFO,
                                        Colors.transparent,
                                      ]),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: height * 0.162 + 16,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 16),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            mangas![index].title ?? '',
                                            // overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.raleway(
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context)
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
                                  borderRadius: BorderRadius.circular(10)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: FadeInImage(
                                  placeholder: MemoryImage(kTransparentImage),
                                  image: NetworkImageWithRetry(
                                      mangas![index].poster ?? ''),
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
              ));
  }

  _search(keyword) async {
    var list = await API.getSearchQuery(keyword);
    setState(() {
      mangas = list;
    });
  }
}
