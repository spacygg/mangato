import 'package:flutter/material.dart';
import 'package:flutter_image/flutter_image.dart';
import 'package:nelo/models/manga.dart';
import 'package:nelo/screens/manga_page.dart';
import 'package:transparent_image/transparent_image.dart';

class MangaCard extends StatelessWidget {
  final Manga manga;
  const MangaCard({Key? key, required this.manga}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MangaPage(manga: manga),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(8),
        width: size.width / 3,
        child: Card(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(
              width: 1,
              color: Colors.white30,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: FadeInImage(
              fit: BoxFit.cover,
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImageWithRetry(manga.poster ?? ''),
            ),
          ),
        ),
      ),
    );
  }
}
