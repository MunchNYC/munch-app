import 'package:flutter/material.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';

class EmptyListViewWidget extends StatelessWidget {
  IconData iconData;
  String text;

  EmptyListViewWidget({this.iconData, this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 24.0),
        Material(
            color: Colors.transparent,
            shape: CircleBorder(
                side: BorderSide(color: Palette.secondaryLight, width: 2.0)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(iconData, color: Palette.secondaryLight, size: 24.0),
            )),
        SizedBox(height: 12.0),
        Text(
          text,
          style: AppTextStyle.style(AppTextStylePattern.heading5,
              color: Palette.secondaryLight, fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}
