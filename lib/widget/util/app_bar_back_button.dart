import 'package:flutter/material.dart';
import 'package:munch/theme/palette.dart';

class AppBarBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        // it already has offset of 20.0 so 4.0 + 20.0 = 24.0
        padding: EdgeInsets.only(left: 4.0),
        child: GestureDetector(
          onTap: () {
            Navigator.maybePop(context);
          },
          child: Icon(Icons.arrow_back_ios, size: 24.0, color: Palette.secondaryLight.withOpacity(0.7)),
        ));
  }
}
