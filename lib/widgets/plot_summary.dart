import 'package:flutter/material.dart';
import 'package:nelo/models/manga.dart';
import 'package:nelo/services/api.dart';

class PlotSummary extends StatelessWidget {
  const PlotSummary({
    Key? key,
    required this.manga,
  }) : super(key: key);
  final Manga manga;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      textColor: Color.fromARGB(255, 104, 208, 240),
      iconColor: Color.fromARGB(255, 104, 208, 240),
      collapsedIconColor: Colors.white,
      title: Text(
        'Overview',
      ),
      childrenPadding: const EdgeInsets.symmetric(vertical: 10),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            manga.description ?? '',
          ),
        ),
      ],
    );
  }
}
