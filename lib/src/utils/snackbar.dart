
import 'package:flutter/material.dart';
import 'package:proyecto_movil/src/utils/colors.dart' as utils;

class Snackbar {
  static void showSnackbar( BuildContext context, GlobalKey<ScaffoldState> key, String text ){
    if (context == null ) return;
    if (key == null) return;
    if (key.currentState == null) return;

    FocusScope.of(context).requestFocus(new FocusNode());

    key.currentState.removeCurrentSnackBar();
    key.currentState.showSnackBar(new SnackBar(
      content: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
      backgroundColor: utils.Colors.appColor,
      duration: Duration(seconds: 4) 
    ));
  }
}
