import 'package:flutter/material.dart';
import 'package:munch/model/user.dart';
import 'package:munch/service/munch/munch_bloc.dart';
import 'package:munch/service/munch/munch_event.dart';
import 'package:munch/theme/dimensions.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/navigation_helper.dart';
import 'package:munch/widget/util/custom_button.dart';

class KickMemberAlertDialog extends StatelessWidget {
  User user;
  String munchId;
  MunchBloc munchBloc;

  KickMemberAlertDialog({this.user, this.munchId, this.munchBloc});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: AppDimensions.padding(AppPaddingType.screenOnly).copyWith(bottom: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            CustomButton(
                minWidth: double.infinity,
                borderRadius: 8.0,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                color: Palette.background,
                textColor: Palette.error,
                content: Text(App.translate("kick_member_alert_dialog.confirm_button.text"),
                    style: AppTextStyle.style(AppTextStylePattern.heading6,
                        fontWeight: FontWeight.w500, color: Palette.error)),
                onPressedCallback: () {
                  // close dialog
                  NavigationHelper.popRoute(context);

                  munchBloc.add(KickMemberEvent(munchId: munchId, userId: user.uid));
                }),
            SizedBox(height: 12.0),
            CustomButton(
                minWidth: double.infinity,
                borderRadius: 8.0,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                color: Palette.background,
                textColor: Palette.hyperlink,
                content: Text(App.translate("kick_member_alert_dialog.cancel_button.text"),
                    style: AppTextStyle.style(AppTextStylePattern.heading6,
                        fontWeight: FontWeight.w500, color: Palette.hyperlink)),
                onPressedCallback: () {
                  // close dialog
                  NavigationHelper.popRoute(context);
                })
          ],
        ));
  }
}
