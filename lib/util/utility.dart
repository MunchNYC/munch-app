import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:munch/config/localizations.dart';

class Utility{
  static void showFlushbar(String text, BuildContext context, {Duration duration = const Duration(seconds: 3)}){
    WidgetsBinding.instance.addPostFrameCallback((_) => Flushbar(
      duration: duration,
      messageText: Text(text, style: TextStyle(color: Colors.white)),
    ).show(context));
  }

  static void showErrorFlushbar(String text, BuildContext context, {Duration duration = const Duration(seconds: 3)}){
    WidgetsBinding.instance.addPostFrameCallback((_) => Flushbar(
      duration: duration,
      messageText: Text(text, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.red,
    ).show(context));
  }
}