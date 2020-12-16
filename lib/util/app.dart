import 'dart:io';

import 'package:device_info/device_info.dart';
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

  static bool use24HoursFormat;

  static AppLocalizations appLocalizations;

  static String deviceId;

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static void _initAppLocalizations(BuildContext context) {
    appLocalizations = AppLocalizations.of(context);
  }

  static void _initScreenProperties(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    screenWidth = mediaQueryData.size.width;
    screenHeight = mediaQueryData.size.height;
    devicePixelRatio = mediaQueryData.devicePixelRatio;
    textScaleFactor = mediaQueryData.textScaleFactor;
    use24HoursFormat = mediaQueryData.alwaysUse24HourFormat;
  }

  static void initAppContext(BuildContext context) {
    _initAppLocalizations(context);
    _initScreenProperties(context);
  }

  static String translate(String key) {
    return appLocalizations.text(key);
  }

  static initializeDeviceData() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId = iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = androidDeviceInfo.androidId; // unique ID on Android
    }
  }
}
