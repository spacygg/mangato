import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:nelo/models/manga.dart';
import 'package:nelo/services/database.dart';
import 'package:nelo/widgets/chapter_list.dart';
import 'package:nelo/widgets/movie_header.dart';
import 'package:nelo/widgets/plot_summary.dart';
import 'package:transparent_image/transparent_image.dart';

class MangaPage extends StatefulWidget {
  Manga manga;
  MangaPage({Key? key, required this.manga}) : super(key: key);

  @override
  _MangaPageState createState() => _MangaPageState();
}

class _MangaPageState extends State<MangaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.manga.title ?? ''),
        centerTitle: true,
        actions: [
          FutureBuilder(
            future: BookmarkHandler().isBookmarked(anime: widget.manga),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              bool isBookmarked = false;
              if (snapshot.hasData) {
                isBookmarked = snapshot.data as bool;
              }
              return isBookmarked
                  ? IconButton(
                      onPressed: () {
                        BookmarkHandler().delete(widget.manga);
                        setState(() {});
                      },
                      icon: Icon(Icons.favorite),
                    )
                  : IconButton(
                      onPressed: () {
                        BookmarkHandler().insert(widget.manga);
                        setState(() {});
                      },
                      icon: Icon(Icons.favorite_outline),
                    );
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  MangaHeader(manga: widget.manga),
                  PlotSummary(manga: widget.manga),
                  ChapterList(manga: widget.manga),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
