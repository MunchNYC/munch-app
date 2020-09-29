import 'package:flutter/material.dart';
import 'package:munch/config/localizations.dart';

class App {
  static const double REF_DEVICE_PIXEL_RATIO = 1.75;

  static const double REF_DEVICE_HEIGHT = 800;
  static const double REF_DEVICE_WIDTH = 440;

  static double screenWidth;
  static double screenHeight;
  static double devicePixelRatio;
  static double textScaleFactor;

  static AppLocalizations appLocalizations;

  static void initAppLocalizations(BuildContext context){
    appLocalizations = AppLocalizations.of(context);
  }

  static void initScreenProperties(BuildContext context){
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    textScaleFactor = MediaQuery.of(context).textScaleFactor;
  }

  static void initAppContext(BuildContext context){
    initAppLocalizations(context);
    initScreenProperties(context);
  }

  static String translate(String key){
    return appLocalizations.text(key);
  }
}