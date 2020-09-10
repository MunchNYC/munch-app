import 'package:flutter/material.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';

class ErrorPageWidget extends StatelessWidget{
  String errorMessage;
  String description;

  ErrorPageWidget({this.errorMessage, this.description});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 24.0),
            Icon(
              Icons.error_outline,
              color: Palette.secondaryDark,
              size: 40.0,
            ),
            SizedBox(height: 4.0),
            Text(
              errorMessage ?? App.translate("error_page_widget.text"),
              style: AppTextStyle.style(AppTextStylePattern.heading6, color: Palette.secondaryLight, fontWeight: FontWeight.normal),
            ),
            if(description != null) SizedBox(height: 8.0),
            if(description != null)
            Text(
              "(" + description + ")",
              style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.secondaryLight, fontWeight: FontWeight.bold),
            )
          ],
        ));
  }
}