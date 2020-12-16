import 'package:flutter/material.dart';

/*
  Zero-height status bar that should be extended behind body and it will override status bar icon colors
 */
class AppStatusBar {
  static AppBar getAppStatusBar({Brightness iconBrightness}) {
    return AppBar(
      backgroundColor: Colors.transparent,
      toolbarHeight: 0.0,
      brightness: iconBrightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark,
    );
  }
}
