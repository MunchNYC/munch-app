import 'package:flutter/cupertino.dart';
import 'package:munch/config/constants.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/util/app.dart';

class SplashLogo extends StatelessWidget {
  bool isHero;

  SplashLogo({this.isHero = true});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Palette.background,
        height: double.infinity,
        padding: EdgeInsets.only(left: 48.0, right: 48.0),
        // can be double.infinity but this is more scalable for bigger screens
        width: App.REF_DEVICE_WIDTH,
        child: Center(
            child: Hero(
                tag: isHero ? WidgetKeys.SPLASH_LOGO_HERO_TAG : "",
                child: Image(
                    image: AssetImage("assets/images/logo/logo_NoBG_Black_outline.png"),
                    color: Palette.secondaryDark),
              ),
        )
    );
  }

}