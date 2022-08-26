import 'package:flutter/material.dart';

class ListTitle extends StatelessWidget {
  String title;
  ListTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 10),
      child: Row(
        children: [
          Text("$title"),
          Text(
            " Manga",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
