import 'package:flutter/material.dart';
import 'package:slide_puzzle/constants/colors.dart';

class PuzzleTheme {
  static ThemeData get lightTheme {
    //1
    return ThemeData(
        //2
        primaryColor: PuzzleColors.lightTextColor,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Montserrat', //3
        buttonTheme: ButtonThemeData(
          // 4
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          // buttonColor: CustomColors.lightPurple,
        ));
  }
}
