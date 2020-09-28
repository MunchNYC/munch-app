import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:munch/config/localizations.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/util/app.dart';
import 'package:url_launcher/url_launcher.dart';

class Utility{
  static void showFlushbar(String text, BuildContext context,
      {Duration duration = const Duration(seconds: 3),
        Color color = Palette.hyperlink, Color textColor: Palette.background}){
    WidgetsBinding.instance.addPostFrameCallback((_) => Flushbar(
      duration: duration,
      messageText: Text(text, style: TextStyle(color: textColor)),
        backgroundColor: color
    ).show(context));
  }

  static void showErrorFlushbar(String text, BuildContext context,
      {Duration duration = const Duration(seconds: 3),
        Color color = Palette.error, Color textColor: Palette.background}){
    WidgetsBinding.instance.addPostFrameCallback((_) => Flushbar(
      duration: duration,
      messageText: Text(text, style: TextStyle(color: textColor)),
      backgroundColor: color,
    ).show(context));
  }

  static void launchUrl(BuildContext context, String url) async{
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        Utility.showFlushbar(App.translate("url_launcher.error.message"), context);
      }
  }
}