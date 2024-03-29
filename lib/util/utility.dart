import 'dart:math';
import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_route.dart' as route;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:munch/config/constants.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/util/app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';

class Utility {
  static const _TOTAL_MUNCH_NAME_PLACEHOLDERS = 65;

  static void showFlushbar(String text, BuildContext context,
      {Duration duration = const Duration(seconds: 3),
      Color color = Palette.hyperlink,
      Color textColor: Palette.background}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final _route = route.showFlushbar(
        context: context,
        flushbar: Flushbar(
            duration: duration, messageText: Text(text, style: TextStyle(color: textColor)), backgroundColor: color),
      );

      Navigator.of(context, rootNavigator: true).push(_route);
    });
  }

  static void showErrorFlushbar(String text, BuildContext context,
      {Duration duration = const Duration(seconds: 3),
      Color color = const Color(0xFFF5F5FB),
      Color textColor: Palette.error}) {
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

  static void launchUrl(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Utility.showFlushbar(App.translate("url_launcher.error.message"), context);
    }
  }

  static String getTimezoneNameFromOffset(Duration offset) {
    for (tz.Location location in tz.timeZoneDatabase.locations.values) {
      if (location.currentTimeZone.offset == offset.inMilliseconds) {
        return location.name;
      }
    }

    return null;
  }

  static String convertEnumValueToString(var enumState) {
    return enumState.toString().substring(enumState.toString().indexOf('.') + 1);
  }

  static DateTime convertUnixTimestampToUTC(int value) {
    return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
  }

  static String convertTo24HourFormat(String dateTime12HoursString) {
    return DateFormat("HH:mm").format(DateFormat("y-M-d hh:mm aa").parse(dateTime12HoursString));
  }

  static Future<bool> shouldShowOnboarding() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool shouldShowOnboarding = sharedPreferences.getBool(StorageKeys.SHOULD_SHOW_ONBOARDING);

    // SharedPreferences are null by default && until we set them elsewhere.
    return shouldShowOnboarding == null ? true : false;
  }

  static String createRandomGroupName() {
    int randomPrefix = Random().nextInt(_TOTAL_MUNCH_NAME_PLACEHOLDERS);
    int randomSuffix = Random().nextInt(_TOTAL_MUNCH_NAME_PLACEHOLDERS);
    return App.translate("random_munch_group_prefix$randomPrefix") +
        " " +
        App.translate("random_munch_group_suffix$randomSuffix");
  }
}
