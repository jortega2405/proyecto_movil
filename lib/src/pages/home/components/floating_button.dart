import 'package:flutter/material.dart';


class HomeImage extends StatelessWidget {
  const HomeImage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/img/image.png',
          
        ),
      ],
    );
  }
}