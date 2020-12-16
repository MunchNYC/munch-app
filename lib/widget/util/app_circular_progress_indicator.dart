import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:munch/theme/palette.dart';

class AppCircularProgressIndicator extends StatelessWidget {
  final bool centered;
  final Color color;

  AppCircularProgressIndicator(
      {this.centered = true, this.color = Palette.secondaryDark});

  @override
  Widget build(BuildContext context) {
    Widget _spinKitThreeBounce = SpinKitThreeBounce(
      color: color,
      size: 32.0,
    );

    if (centered) {
      _spinKitThreeBounce = Center(child: _spinKitThreeBounce);
    }

    return _spinKitThreeBounce;
  }
}
