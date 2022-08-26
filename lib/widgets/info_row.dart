import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  var cle, value, more;
  InfoRow({Key? key, required this.cle, required this.value, this.more})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Text.rich(
        TextSpan(children: [
          TextSpan(
            text: cle,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const TextSpan(text: ' '),
          TextSpan(
            text: value.runtimeType == double
                ? value.toStringAsFixed(2)
                : value.toString(),
            style: const TextStyle(fontWeight: FontWeight.w100),
          ),
          TextSpan(
            text: more,
            style: const TextStyle(fontWeight: FontWeight.w100),
          ),
        ]),
      ),
    );
  }
}
