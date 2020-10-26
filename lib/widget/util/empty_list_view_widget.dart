import 'dart:io';

import 'package:flutter/material.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';

class EmptyListViewWidget extends StatelessWidget{
  IconData iconData;
  String text;

  EmptyListViewWidget({this.iconData, this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        // on iOS refresh indicator is moving content below it, so we have to overcome overflowing by extending padding on iOS
        padding: EdgeInsets.only(bottom: Platform.isIOS ? App.screenHeight * 0.5 : 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 24.0),
            Material(
                color: Colors.transparent,
                shape: CircleBorder(side: BorderSide(color: Palette.secondaryLight, width: 2.0)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    iconData,
                    color: Palette.secondaryLight,
                    size: 24.0
                  ),
                )),
            SizedBox(height: 12.0),
            Text(
              text,
              style: AppTextStyle.style(AppTextStylePattern.heading5, color: Palette.secondaryLight, fontWeight: FontWeight.normal),
            ),
          ],
        )
      )
    );
  }
}