import 'package:flutter/material.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/widget/util/error_page_widget.dart';

import 'custom_button.dart';

class ErrorListWidget extends StatelessWidget{
  Function actionCallback;

  ErrorListWidget({this.actionCallback});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: 48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
              ErrorPageWidget(),
              SizedBox(height: 16.0),
              CustomButton(
                  flat: true,
                  color: Colors.transparent,
                  borderRadius: 16.0,
                  borderWidth: 1.0,
                  borderColor: Palette.secondaryDark,
                  textColor: Palette.secondaryDark,
                  padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 12.0),
                  content: Text(App.translate("error_list_widget.action_button.text"), style: AppTextStyle.style(AppTextStylePattern.heading6SecondaryDark, fontWeight: FontWeight.w500)),
                  onPressedCallback: actionCallback
              )
          ],
        )
      )
    );
  }
}