import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/util/app.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flushbar/flushbar_route.dart' as route;

class Utility{

  static void showFlushbar(String text, BuildContext context,
      {Duration duration = const Duration(seconds: 3),
        Color color = Palette.hyperlink, Color textColor: Palette.background}){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final _route = route.showFlushbar(
          context: context,
          flushbar: Flushbar(
              duration: duration,
              messageText: Text(text, style: TextStyle(color: textColor)),
              backgroundColor: color
          ),
        );

        Navigator.of(context, rootNavigator: true).push(_route);
      });
  }

  static void showErrorFlushbar(String text, BuildContext context,
      {Duration duration = const Duration(seconds: 3),
        Color color = const Color(0xFFF5F5FB), Color textColor: Palette.error}){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final _route = route.showFlushbar(
        context: context,
        flushbar: Flushbar(
          duration: duration,
          messageText: Text(text, style: TextStyle(color: textColor)),
          backgroundColor: color,
        ),
      );

      Navigator.of(context, rootNavigator: true).push(_route);
    });
  }

  static void launchUrl(BuildContext context, String url) async{
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        Utility.showFlushbar(App.translate("url_launcher.error.message"), context);
      }
  }

  static String getTimezoneNameFromOffset(Duration offset){
    for(tz.Location location in tz.timeZoneDatabase.locations.values){
      if(location.currentTimeZone.offset == offset.inMilliseconds){
        return location.name;
      }
    }

    return null;
  }

  static String convertEnumValueToString(var enumState){
    return enumState.toString().substring(enumState.toString().indexOf('.') + 1);
  }

  static DateTime convertUnixTimestampToUTC(int value){
    return DateTime.fromMicrosecondsSinceEpoch(value * 1000, isUtc: true);
  }
}