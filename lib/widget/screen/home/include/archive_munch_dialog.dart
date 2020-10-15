import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/service/munch/munch_bloc.dart';
import 'package:munch/service/munch/munch_event.dart';
import 'package:munch/service/munch/munch_state.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/navigation_helper.dart';
import 'package:munch/widget/util/custom_button.dart';
import 'package:munch/widget/util/custom_form_field.dart';

class ArchiveMunchDialog extends StatelessWidget{
  MunchBloc munchBloc;
  Munch munch;

  ArchiveMunchDialog({this.munchBloc, this.munch});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(munch.matchedRestaurantName,
                style: AppTextStyle.style(AppTextStylePattern.heading2, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
            SizedBox(height: 24.0),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: _dislikeButton()
                ),
                SizedBox(width: 20.0),
                Expanded(
                  child: _neutralButton()
                ),
                SizedBox(width: 20.0),
                Expanded(
                  child: _likeButton()
                ),
              ],
            ),
            SizedBox(height: 24.0),
            _didNotGoLabel()
          ]
      ),
    );
  }

  Widget _dislikeButton(){
    return CustomButton(
        padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 16.0),
        elevation: 8.0,
        borderRadius: 8.0,
        color: Palette.background,
        textColor: Palette.primary,
        content: Column(
          children: [
            Text("Disliked",style: AppTextStyle.style(AppTextStylePattern.heading5, fontWeight: FontWeight.w500)),
            SizedBox(height: 4.0),
            Text("👎", style: AppTextStyle.style(AppTextStylePattern.heading5, fontWeight: FontWeight.w500)),
          ],
        )
    );
  }

  Widget _neutralButton(){
    return CustomButton(
        padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 16.0),
        elevation: 8.0,
        borderRadius: 8.0,
        color: Palette.background,
        textColor: Palette.primary,
        content: Column(
          children: [
            Text("Neutral", style: AppTextStyle.style(AppTextStylePattern.heading5, fontWeight: FontWeight.w500)),
            SizedBox(height: 4.0),
            Text("🤷", style: AppTextStyle.style(AppTextStylePattern.heading5, fontWeight: FontWeight.w500)),
          ],
        )
    );
  }

  Widget _likeButton(){
    return CustomButton(
        padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 16.0),
        elevation: 8.0,
        borderRadius: 8.0,
        color: Palette.background,
        textColor: Palette.primary,
        content: Column(
          children: [
            Text("Liked", style: AppTextStyle.style(AppTextStylePattern.heading5, fontWeight: FontWeight.w500)),
            SizedBox(height: 4.0),
            Text("👍", style: AppTextStyle.style(AppTextStylePattern.heading5, fontWeight: FontWeight.w500)),
          ],
        )
    );
  }

  Widget _didNotGoLabel(){
    return CustomButton(
      padding: EdgeInsets.zero,
      color: Colors.transparent,
      textColor: Palette.secondaryDark,
      flat: true,
      content: Text("Did not go", style: AppTextStyle.style(AppTextStylePattern.heading5SecondaryDark, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
    );
  }
}