import 'package:flutter/material.dart';
import 'package:munch/service/munch/munch_bloc.dart';
import 'package:munch/service/munch/munch_event.dart';
import 'package:munch/theme/dimensions.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/navigation_helper.dart';
import 'package:munch/widget/util/custom_button.dart';

class LeaveMunchAlertDialog extends StatelessWidget{
  String munchId;
  MunchBloc munchBloc;

  LeaveMunchAlertDialog({this.munchId, this.munchBloc});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: AppDimensions.padding(AppPaddingType.screenOnly).copyWith(bottom: 24.0),
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
                  content: Text(App.translate("leave_munch_alert_dialog.confirm_button.text"), style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w500, color: Palette.error)),
                  onPressedCallback: (){
                    // close dialog
                    NavigationHelper.popRoute(context, rootNavigator: true);

                    munchBloc.add(LeaveMunchEvent(munchId: munchId));
                  },
                ),
              SizedBox(height: 12.0),
              CustomButton(
                minWidth: double.infinity,
                borderRadius: 8.0,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                color: Palette.background,
                textColor: Palette.hyperlink,
                content: Text(App.translate("leave_munch_alert_dialog.cancel_button.text"), style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w500, color: Palette.hyperlink)),
                onPressedCallback: (){
                  // close dialog
                  NavigationHelper.popRoute(context, rootNavigator: true);
                },
              )
            ],
        )
    );
  }

}