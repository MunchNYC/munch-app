import 'package:flutter/cupertino.dart';

enum AppPaddingType {
  screenOnly,
  screenWithAppBar
}

class AppDimensions{
  static List<EdgeInsets> _appPaddingTypes = [
      EdgeInsets.fromLTRB(24.0, 48.0, 24.0, 24.0),
      EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 24.0)
  ];

  static EdgeInsets padding(AppPaddingType pd){
    return _appPaddingTypes[pd.index];
  }
}