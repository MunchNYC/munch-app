import 'package:flutter/material.dart';
import 'package:munch/theme/dimensions.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/navigation_helper.dart';
import 'package:munch/widget/util/custom_button.dart';

class KickMemberAlertDialog extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.secondaryLight.withAlpha(220),
      body: Container(
        padding: AppDimensions.padding(AppPaddingType.screenOnly).copyWith(bottom: 24.0),
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child:  Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
            CustomButton(
                minWidth: double.infinity,
                borderRadius: 8.0,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                color: Palette.background,
                textColor: Palette.error,
                  content: Text("kick_member_alert_dialog.confirm_button.text", style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w500, color: Palette.error)),
                  onPressedCallback: (){
    
                  },
                ),
              SizedBox(height: 12.0),
              CustomButton(
                minWidth: double.infinity,
                borderRadius: 8.0,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                color: Palette.background,
                textColor: Palette.hyperlink,
                content: Text("kick_member_alert_dialog.cancel_button.text", style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w500, color: Palette.hyperlink)),
                onPressedCallback: (){
                  NavigationHelper.popRoute(context, rootNavigator: true);
                },
              )
            ],
          )
        )
    );
  }

}