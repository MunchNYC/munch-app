import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:munch/theme/palette.dart';

class AppCircularProgressIndicator extends StatelessWidget {
  final bool centered;

  AppCircularProgressIndicator({this.centered = true});

  @override
  Widget build(BuildContext context) {
    Widget _spinKitThreeBounce = SpinKitThreeBounce(
      color: Palette.secondaryDark,
      size: 32.0,
    );

    if(centered){
      _spinKitThreeBounce = Center(child: _spinKitThreeBounce);
    }

    return _spinKitThreeBounce;
  }
}
