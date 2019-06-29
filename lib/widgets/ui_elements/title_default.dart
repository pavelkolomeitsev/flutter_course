import 'package:flutter/material.dart';

class TitleDefault extends StatelessWidget {
  final String title;

  TitleDefault(this.title);

  @override
  Widget build(BuildContext context) {
    return new Text(
      title,
      style: new TextStyle(
        fontSize: 26.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'Oswald',
      ),
    );
  }
}
