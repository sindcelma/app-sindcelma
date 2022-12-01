import 'package:flutter/material.dart';

enum TypeColor {
  primary,
  secondary,
  text
}


class SindcelmaTheme {

  static Color? color_primary   = Colors.redAccent[700];
  static Color? color_secondary = Colors.green[900];
  static Color? color_text      = Colors.black54;

  static ThemeData get(){

    return ThemeData(
      primaryColor: color_primary,
      fontFamily: 'OpenSans'
    );

  }

}
