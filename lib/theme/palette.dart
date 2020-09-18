import 'dart:math';

import 'package:flutter/material.dart';

class Palette {
  static const Color primary = Colors.black;
  static const Color background = Colors.white;
  static const Color secondaryDark = Color(0xFFFF6A6A);
  static const Color secondaryLight = Color(0xFF959595);
  static const Color ternaryDark = Color(0xFFFF2C5B);
  static const Color error = Color(0xFFFF0000);
  static const Color success = Color(0xFF228B22);
  static const Color warning = Color(0xFFFFAE42);
  static const Color hyperlink = Color(0xFF007AFF);

  static MaterialColor generateMaterialColor(Color color) {
    return MaterialColor(color.value, {
      50: tintColor(color, 0.9),
      100: tintColor(color, 0.8),
      200: tintColor(color, 0.6),
      300: tintColor(color, 0.4),
      400: tintColor(color, 0.2),
      500: color,
      600: shadeColor(color, 0.1),
      700: shadeColor(color, 0.2),
      800: shadeColor(color, 0.3),
      900: shadeColor(color, 0.4),
    });
  }

  static int tintValue(int value, double factor) =>
      max(0, min((value + ((255 - value) * factor)).round(), 255));

  static Color tintColor(Color color, double factor) => Color.fromRGBO(
      tintValue(color.red, factor),
      tintValue(color.green, factor),
      tintValue(color.blue, factor),
      1);

  static int shadeValue(int value, double factor) =>
      max(0, min(value - (value * factor).round(), 255));

  static Color shadeColor(Color color, double factor) => Color.fromRGBO(
      shadeValue(color.red, factor),
      shadeValue(color.green, factor),
      shadeValue(color.blue, factor),
      1);
}