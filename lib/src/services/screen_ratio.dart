import 'package:flutter/material.dart';

class ScreenRatio {
  static double? heightRatio;
  static double? widthRatio;

  static setScreenRatio({context, required Size size}) {
    heightRatio = size.height / 667.0;
    widthRatio = size.width / 375.0;
  }
}
