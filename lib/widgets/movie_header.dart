import 'package:flutter/material.dart';
import 'package:flutter_image/flutter_image.dart';
import 'package:nelo/models/manga.dart';
import 'package:nelo/services/api.dart';
import 'package:nelo/widgets/info_row.dart';
import 'package:transparent_image/transparent_image.dart';

class MangaHeader extends StatelessWidget {
  Manga manga;
  MangaHeader({Key? key, required this.manga}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 0.5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: NetworkImageWithRetry(manga.poster ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: FutureBuilder(
                future: API.getMangaDetails(manga.url ?? ''),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: SizedBox(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  Details details = snapshot.data as Details;
                  return ListView(
                    children: List.generate(
                            1,
                            (index) =>
                                InfoRow(cle: 'Title', value: manga.title)) +
                        List.generate(
                          details.key!.length,
                          (index) => InfoRow(
                            cle: details.key![index],
                            value: details.value![index],
                          ),
                        ) +
                        List.generate(
                          details.key1!.length,
                          (index) => InfoRow(
                            cle: details.key1![index],
                            value: details.value1![index],
                          ),
                        ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
