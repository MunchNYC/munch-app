import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/navigation_helper.dart';

class SaveChangesAlertDialog extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Padding(
          padding: EdgeInsets.only(bottom:12.0),
          child: Text(App.translate("save_changes_alert_dialog.title"), style: AppTextStyle.style(AppTextStylePattern.body3, fontSizeOffset: 1.0, fontWeight: FontWeight.w600))
      ),
      content: Text(App.translate("save_changes_alert_dialog.description"), style: AppTextStyle.style(AppTextStylePattern.body2, fontSizeOffset: 1.0)),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text(App.translate("save_changes_alert_dialog.confirm_button.text"), style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w400, color: Palette.hyperlink)),
          onPressed: (){
            // return result to previous route, in order to refresh things
            NavigationHelper.popRoute(context, rootNavigator: true);
          },
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          isDestructiveAction: true,
          child: Text(App.translate("save_changes_alert_dialog.cancel_button.text"), style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w500, color: Palette.error)),
          onPressed: (){
            // return result to previous route, in order to refresh things
            NavigationHelper.popRoute(context, rootNavigator: true);
          },
        )
      ],
    );
  }
}