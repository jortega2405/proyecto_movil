import 'package:flutter/material.dart';

class ButtonApp extends StatelessWidget {

  Color color;
  Color textColor;
  String text;
  Function onPressed;
  

  ButtonApp({
    this.color,
    this.textColor = Colors.white,
    this.onPressed,
    @required this.text
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: (){
        onPressed();
      },
      color: color,
      textColor: textColor,
      child: Text(text),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}