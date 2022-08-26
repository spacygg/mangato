import 'package:flutter/material.dart';
import 'package:nelo/models/manga.dart';
import 'package:nelo/services/api.dart';
import 'package:nelo/widgets/movie_card.dart';

class HorizontalList extends StatelessWidget {
  final String type;
  HorizontalList({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: _future(),
        builder: (context, snapshot) {
          // return Container();
          if (!snapshot.hasData) {
            return SizedBox(
              height: size.height / 3,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          List<Manga> list = snapshot.data as List<Manga>;
          return SizedBox(
            height: size.height / 3,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              itemBuilder: (context, index) => MangaCard(
                manga: list[index],
              ),
            ),
          );
        });
  }

  Future _future() {
    return API.getMangaList(sort: type);
  }
}
