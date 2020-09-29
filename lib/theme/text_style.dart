import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/util/app.dart';

enum AppTextStylePattern {
  body,
  bodyInverse,
  bodySecondaryDark,
  bodyBolded,
  bodyInverseBolded,
  bodySecondaryDarkBolded,
  body2,
  body2Inverse,
  body2SecondaryDark,
  body2Bolded,
  body2InverseBolded,
  body2SecondaryDarkBolded,
  body3,
  body3Inverse,
  body3SecondaryDark,
  body3Bolded,
  body3InverseBolded,
  body3SecondaryDarkBolded,
  heading1,
  heading1Inverse,
  heading1SecondaryDark,
  heading2,
  heading2Inverse,
  heading2SecondaryDark,
  heading3,
  heading3Inverse,
  heading3SecondaryDark,
  heading4,
  heading4Inverse,
  heading4SecondaryDark,
  heading5,
  heading5Inverse,
  heading5SecondaryDark,
  heading6,
  heading6Inverse,
  heading6SecondaryDark,
  placeholderLink,
  placeholderLinkBolded,
  placeholderLink2,
  placeholderLink2Bolded,
  placeholderLink3,
  placeholderLink3Bolded,
  error,
  errorBolded,
  error2,
  error2Bolded,
  hyperlink
}

enum AppStrutStylePattern {
  body,
  body2,
  body3,
  heading1,
  heading2,
  heading3,
  heading4,
  heading5,
  heading6,
  placeholderLink,
  placeholderLink2,
  placeholderLink3,
  error,
  error2,
  hyperlink,
  hyperlink2
}

class AppTextStyle{
  static const String APP_FONT = 'Montserrat';
  static const FontWeight DEFAULT_FONT_WEIGHT = FontWeight.w500;

  static List<TextStyle> _appTextStyles = [
    TextStyle(color: Palette.primary, fontSize: 12.0),
    TextStyle(color: Palette.background, fontSize: 12.0),
    TextStyle(color: Palette.secondaryDark, fontSize: 12.0),
    TextStyle(color: Palette.primary, fontSize: 12.0, fontWeight: FontWeight.bold),
    TextStyle(color: Palette.background, fontSize: 12.0, fontWeight: FontWeight.bold),
    TextStyle(color: Palette.secondaryDark, fontSize: 12.0, fontWeight: FontWeight.bold),
    TextStyle(color: Palette.primary, fontSize: 14.0),
    TextStyle(color: Palette.background, fontSize: 14.0),
    TextStyle(color: Palette.secondaryDark, fontSize: 14.0),
    TextStyle(color: Palette.primary, fontSize: 14.0, fontWeight: FontWeight.bold),
    TextStyle(color: Palette.background, fontSize: 14.0, fontWeight: FontWeight.bold),
    TextStyle(color: Palette.secondaryDark, fontSize: 14.0, fontWeight: FontWeight.bold),
    TextStyle(color: Palette.primary, fontSize: 18.0),
    TextStyle(color: Palette.background, fontSize: 18.0),
    TextStyle(color: Palette.secondaryDark, fontSize: 18.0),
    TextStyle(color: Palette.primary, fontSize: 18.0, fontWeight: FontWeight.bold),
    TextStyle(color: Palette.background, fontSize: 18.0, fontWeight: FontWeight.bold),
    TextStyle(color: Palette.secondaryDark, fontSize: 18.0, fontWeight: FontWeight.bold),
    TextStyle(color: Palette.primary, fontSize: 38.0, fontWeight: FontWeight.bold),
    TextStyle(color: Palette.background, fontSize: 38.0, fontWeight: FontWeight.bold),
    TextStyle(color: Palette.secondaryDark, fontSize: 38.0, fontWeight: FontWeight.bold),
    TextStyle(color: Palette.primary, fontSize: 30.0, fontWeight: FontWeight.bold),
    TextStyle(color: Palette.background, fontSize: 30.0, fontWeight: FontWeight.bold),
    TextStyle(color: Palette.secondaryDark, fontSize: 30.0, fontWeight: FontWeight.bold),
    TextStyle(color: Palette.primary, fontSize: 28.0, fontWeight: FontWeight.bold),
    TextStyle(color: Palette.background, fontSize: 28.0, fontWeight: FontWeight.bold),
    TextStyle(color: Palette.secondaryDark, fontSize: 28.0, fontWeight: FontWeight.bold),
    TextStyle(color: Palette.primary, fontSize: 24.0, fontWeight: FontWeight.bold),
    TextStyle(color: Palette.background, fontSize: 24.0, fontWeight: FontWeight.bold),
    TextStyle(color: Palette.secondaryDark, fontSize: 24.0, fontWeight: FontWeight.bold),
    TextStyle(color: Palette.primary, fontSize: 22.0, fontWeight: FontWeight.bold),
    TextStyle(color: Palette.background, fontSize: 22.0, fontWeight: FontWeight.bold),
    TextStyle(color: Palette.secondaryDark, fontSize: 22.0, fontWeight: FontWeight.bold),
    TextStyle(color: Palette.primary, fontSize: 20.0, fontWeight: FontWeight.bold),
    TextStyle(color: Palette.background, fontSize: 20.0, fontWeight: FontWeight.bold),
    TextStyle(color: Palette.secondaryDark, fontSize: 20.0, fontWeight: FontWeight.bold),
    TextStyle(color: Palette.secondaryLight, fontSize: 12.0),
    TextStyle(color: Palette.secondaryLight, fontSize: 12.0,  fontWeight: FontWeight.bold),
    TextStyle(color: Palette.secondaryLight, fontSize: 14.0),
    TextStyle(color: Palette.secondaryLight, fontSize: 14.0, fontWeight: FontWeight.bold),
    TextStyle(color: Palette.secondaryLight, fontSize: 18.0),
    TextStyle(color: Palette.secondaryLight, fontSize: 18.0, fontWeight: FontWeight.bold),
    TextStyle(color: Palette.error, fontSize: 12.0),
    TextStyle(color: Palette.error, fontSize: 12.0, fontWeight: FontWeight.bold),
    TextStyle(color: Palette.error, fontSize: 14.0),
    TextStyle(color: Palette.error, fontSize: 14.0, fontWeight: FontWeight.bold),
    TextStyle(color: Palette.hyperlink, fontSize: 12.0),
  ];

  static List<StrutStyle> _appStrutStyles = [
    StrutStyle(fontSize: 12.0, height: 1.2, forceStrutHeight: true),
    StrutStyle(fontSize: 14.0, height: 1.2, forceStrutHeight: true),
    StrutStyle(fontSize: 18.0, height: 1.2, forceStrutHeight: true),
    StrutStyle(fontSize: 38.0, height: 1.2, forceStrutHeight: true),
    StrutStyle(fontSize: 30.0, height: 1.2, forceStrutHeight: true),
    StrutStyle(fontSize: 28.0, height: 1.2, forceStrutHeight: true),
    StrutStyle(fontSize: 24.0, height: 1.2, forceStrutHeight: true),
    StrutStyle(fontSize: 22.0, height: 1.2, forceStrutHeight: true),
    StrutStyle(fontSize: 18.0, height: 1.2, forceStrutHeight: true),
    StrutStyle(fontSize: 12.0, height: 1.2, forceStrutHeight: true),
    StrutStyle(fontSize: 14.0, height: 1.2, forceStrutHeight: true),
    StrutStyle(fontSize: 18.0, height: 1.2, forceStrutHeight: true),
    StrutStyle(fontSize: 12.0, height: 1.2, forceStrutHeight: true),
    StrutStyle(fontSize: 14.0, height: 1.2, forceStrutHeight: true),
    StrutStyle(fontSize: 12.0, height: 1.2, forceStrutHeight: true),
  ];

  static double fontSize(AppTextStylePattern atsp){
    TextStyle textStyle = _appTextStyles[atsp.index];

    return textStyle.fontSize;
  }

  static TextStyle style(AppTextStylePattern atsp, {Color color, FontWeight fontWeight, double fontSizeOffset = 0}){
    TextStyle textStyle = _appTextStyles[atsp.index];

    textStyle = textStyle.copyWith(fontFamily: APP_FONT);

    if(color != null){
      textStyle = textStyle.copyWith(color: color);
    }

    if(fontWeight != null) {
      textStyle = textStyle.copyWith(fontWeight: fontWeight);
    } else if(textStyle.fontWeight == null){
      textStyle = textStyle.copyWith(fontWeight: DEFAULT_FONT_WEIGHT);
    }

    textStyle = textStyle.copyWith(fontSize: textStyle.fontSize + fontSizeOffset);

    double fontSizeScaleFactor = 1.0 / App.textScaleFactor;

    if(App.screenHeight < App.REF_DEVICE_HEIGHT){
      fontSizeScaleFactor *= App.screenHeight / App.REF_DEVICE_HEIGHT;
    }

    if(App.screenWidth < App.REF_DEVICE_WIDTH){
      fontSizeScaleFactor *= App.screenWidth / App.REF_DEVICE_WIDTH;
    }

    textStyle = textStyle.copyWith(fontSize: fontSizeScaleFactor * textStyle.fontSize);

    return textStyle;
  }

  // Strut styles are used for different languages, in order to force text to have same height on different languages
  static StrutStyle strutStyle(AppStrutStylePattern atsp){
    return _appStrutStyles[atsp.index];
  }
}
