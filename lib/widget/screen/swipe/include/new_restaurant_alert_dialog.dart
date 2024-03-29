import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munch/service/munch/munch_bloc.dart';
import 'package:munch/service/munch/munch_event.dart';
import 'package:munch/theme/dimensions.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/navigation_helper.dart';
import 'package:munch/widget/util/custom_button.dart';

class NewRestaurantAlertDialog extends StatelessWidget {
  String munchId;
  MunchBloc munchBloc;

  NewRestaurantAlertDialog({this.munchId, this.munchBloc});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
            padding: AppDimensions.padding(AppPaddingType.screenOnly).copyWith(top: 20.0, bottom: 20.0),
            width: double.infinity,
            color: Palette.background,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(children: [
                  Center(
                      child: Text(App.translate("new_restaurant_alert_dialog.title"),
                          style: AppTextStyle.style(AppTextStylePattern.heading2, fontWeight: FontWeight.w600))),
                  Align(
                      alignment: Alignment.topRight,
                      child: CustomButton(
                        flat: true,
                        padding: EdgeInsets.zero,
                        color: Colors.transparent,
                        textColor: Palette.secondaryLight,
                        content: Text(App.translate("new_restaurant_alert_dialog.cancel_action.text"),
                            style: AppTextStyle.style(AppTextStylePattern.body2,
                                fontWeight: FontWeight.w600, color: Palette.secondaryLight, fontSizeOffset: 1.0)),
                        onPressedCallback: () {
                          // close dialog
                          NavigationHelper.popRoute(context);
                        },
                      ))
                ]),
                SizedBox(height: 20.0),
                Text(App.translate("new_restaurant_alert_dialog.description"),
                    style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center),
                SizedBox(height: 20.0),
                SafeArea(
                    top: false,
                    right: false,
                    left: false,
                    child: CustomButton(
                      flat: true,
                      color: Colors.transparent,
                      borderRadius: 8.0,
                      borderWidth: 1.0,
                      borderColor: Palette.secondaryDark,
                      textColor: Palette.secondaryDark,
                      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                      content: Text(App.translate("new_restaurant_alert_dialog.new_restaurant_button.text"),
                          style: AppTextStyle.style(AppTextStylePattern.body2SecondaryDark, fontSizeOffset: 1.0)),
                      onPressedCallback: () {
                        munchBloc.add(NewMunchRestaurantEvent(munchId: munchId));
                        // close dialog
                        NavigationHelper.popRoute(context);
                      },
                    ))
              ],
            ))
      ],
    );
  }
}
