import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_image/flutter_image.dart';
import 'package:nelo/models/manga.dart';
import 'package:nelo/screens/favorite_page.dart';
import 'package:nelo/screens/search_page.dart';
import 'package:nelo/services/api.dart';
import 'package:nelo/widgets/horizontal_list.dart';
import 'package:nelo/widgets/list_title.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.network(
          'https://manganato.com/themes/hm/images/logo.png',
          height: 50,
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => SearchPage())),
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => FavoritePage())),
            icon: Icon(Icons.favorite),
          )
        ],
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
                    child: ListView(
                      children: [
                        ListTitle(title: "Latest"),
                        HorizontalList(type: ''),
                        ListTitle(title: "Hot"),
                        HorizontalList(type: 'topview'),
                        ListTitle(title: "Newest"),
                        HorizontalList(type: 'newest'),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
