import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munch/service/munch/munch_bloc.dart';
import 'package:munch/theme/dimensions.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/widget/screen/home/include/create_join_dialog.dart';
import 'package:munch/widget/util/custom_button.dart';
import 'package:munch/widget/util/dialog_helper.dart';

class EmptyMunchesListWidget extends StatelessWidget {
  MunchBloc munchBloc;

  EmptyMunchesListWidget({this.munchBloc});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 12.0, left: 24.0, right: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    // needs to be centered Y with arrow left side, and we need to increase padding by that difference
                    padding: EdgeInsets.only(
                        top: 16.0 +
                            (16.0 -
                                AppDimensions.scaleSizeToScreenHeight(16.0))),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                            App.translate(
                                    "empty_munches_list_widget.tutorial.description_row_1.text") +
                                " ",
                            style: AppTextStyle.style(
                                AppTextStylePattern.heading6,
                                fontWeight: FontWeight.w400,
                                color: Palette.primary)),
                        Icon(
                          Icons.add,
                          size: AppDimensions.scaleSizeToScreen(16.0),
                          color: Palette.secondaryDark,
                        ),
                        Text(
                            " " +
                                App.translate(
                                    "empty_munches_list_widget.tutorial.description_row_2.text"),
                            style: AppTextStyle.style(
                                AppTextStylePattern.heading6,
                                fontWeight: FontWeight.w400,
                                color: Palette.primary)),
                      ],
                    )),
                SizedBox(width: 8.0),
                Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(right: 2.0),
                      child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(pi),
                          child: Transform.rotate(
                              angle: -pi / 2,
                              child: ImageIcon(
                                  AssetImage("assets/icons/curvedArrow.png"),
                                  size: 30.0,
                                  color: Palette.secondaryDark))),
                    ))
              ],
            ),
            SizedBox(height: 60.0),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: AppTextStyle.style(AppTextStylePattern.heading6,
                        fontWeight: FontWeight.w400),
                    children: [
                      TextSpan(
                        text: App.translate(
                            "empty_munches_list_widget.tutorial.join_row_1.text"),
                        style: AppTextStyle.style(
                            AppTextStylePattern.heading6SecondaryDark,
                            fontWeight: FontWeight.w500),
                      ),
                      TextSpan(
                        text: " " +
                            App.translate(
                                "empty_munches_list_widget.tutorial.join_row_2.text"),
                      )
                    ])),
            SizedBox(height: 16.0),
            Text(
                "- " +
                    App.translate(
                        "empty_munches_list_widget.tutorial.join_create_row_separator.text") +
                    " -",
                style: AppTextStyle.style(AppTextStylePattern.heading6,
                    fontWeight: FontWeight.w400)),
            SizedBox(height: 16.0),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: AppTextStyle.style(AppTextStylePattern.heading6,
                        fontWeight: FontWeight.w400),
                    children: [
                      TextSpan(
                        text: App.translate(
                            "empty_munches_list_widget.tutorial.create_row_1.text"),
                        style: AppTextStyle.style(
                            AppTextStylePattern.heading6SecondaryDark,
                            fontWeight: FontWeight.w500),
                      ),
                      TextSpan(
                        text: " " +
                            App.translate(
                                "empty_munches_list_widget.tutorial.create_row_2.text"),
                      )
                    ])),
            Expanded(
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage('assets/images/fallingFoodBackground.jpg'),
                      colorFilter: new ColorFilter.mode(
                          Colors.black.withOpacity(0.3), BlendMode.dstATop),
                      alignment: Alignment.topCenter,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                      padding: EdgeInsets.only(top: 60.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomButton(
                              content: Text(
                                  App.translate(
                                      "empty_munches_list_widget.start_button.text"),
                                  style: AppTextStyle.style(
                                      AppTextStylePattern.heading6Inverse,
                                      fontWeight: FontWeight.w400)),
                              minWidth: double.infinity,
                              borderRadius: 12.0,
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              color: Palette.secondaryDark,
                              textColor: Palette.background,
                              onPressedCallback: () {
                                DialogHelper(
                                        dialogContent: CreateJoinDialog(
                                            munchBloc: munchBloc),
                                        rootNavigator: true)
                                    .show(context);
                              }),
                        ],
                      ))),
            )
          ],
        ));
  }
}
