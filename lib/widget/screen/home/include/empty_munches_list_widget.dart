import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/widget/util/custom_button.dart';

// TODO: In-progress
class EmptyMunchesListWidget extends StatelessWidget{
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
            children: [
              Text("Tap the ", style: AppTextStyle.style(AppTextStylePattern.body3, color: Palette.primary)),
              CustomButton(
                color: Palette.background,
                padding: EdgeInsets.zero,
                content: Icon(
                  Icons.add,
                  size: 14,
                  color: Palette.secondaryDark,
                ),
                flat: true,
                onPressedCallback: (){}
              ),
              Text(" to get started", style: AppTextStyle.style(AppTextStylePattern.body3, color: Palette.primary)),
              Padding(
                padding: EdgeInsets.only(right: 4.0, bottom: 20.0),
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child: Transform.rotate(angle: -pi / 2, child: ImageIcon(AssetImage("assets/icons/curvedArrow.png"), size: 28.0, color: Palette.secondaryDark))
                ),
              )
            ],
          )
        ],
      )
    );
  }
  
}