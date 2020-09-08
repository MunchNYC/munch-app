import 'package:flutter/material.dart';
import 'package:munch/theme/palette.dart';

class AppCircularProgressIndicator extends StatelessWidget {
  final double strokeWidth;
  final bool centered;

  AppCircularProgressIndicator({this.strokeWidth = 4.0, this.centered = true});

  @override
  Widget build(BuildContext context) {
    Widget _circularProgressIndicator =  CircularProgressIndicator(
        backgroundColor: Palette.secondaryDark,
        valueColor: AlwaysStoppedAnimation<Color>(Palette.secondaryLight),
        strokeWidth: this.strokeWidth,
    );

    if(centered){
      _circularProgressIndicator = Center(child: _circularProgressIndicator);
    }

    return _circularProgressIndicator;
  }
}
