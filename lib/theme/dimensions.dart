import 'package:flutter/cupertino.dart';
import 'package:munch/util/app.dart';

enum AppPaddingType { screenOnly, screenWithAppBar }

class AppDimensions {
  static List<EdgeInsets> _appPaddingTypes = [
    EdgeInsets.fromLTRB(24.0, 48.0, 24.0, 0.0),
    EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0.0)
  ];

  static EdgeInsets padding(AppPaddingType pd) {
    return _appPaddingTypes[pd.index];
  }

  static double scaleSizeToScreen(double size) {
    if (App.screenHeight < App.REF_DEVICE_HEIGHT) {
      size *= App.screenHeight / App.REF_DEVICE_HEIGHT;
    }

    if (App.screenWidth < App.REF_DEVICE_WIDTH) {
      size *= App.screenWidth / App.REF_DEVICE_WIDTH;
    }

    return size;
  }

  static double scaleSizeToScreenHeight(double size) {
    if (App.screenHeight < App.REF_DEVICE_HEIGHT) {
      size *= App.screenHeight / App.REF_DEVICE_HEIGHT;
    }

    return size;
  }

  static double scaleSizeToScreenWidth(double size) {
    if (App.screenWidth < App.REF_DEVICE_WIDTH) {
      size *= App.screenWidth / App.REF_DEVICE_WIDTH;
    }

    return size;
  }
}
