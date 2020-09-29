import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/service/munch/munch_bloc.dart';
import 'package:munch/service/munch/munch_event.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/navigation_helper.dart';
import 'package:shimmer/shimmer.dart';

class MunchListWidgetSkeleton extends StatelessWidget {
  int index;

  MunchListWidgetSkeleton({this.index});

  // 3 different combinations
  List<List<double>> _skeletonScreenWidthPercentages= [
      [0.5, 0.2, 0.3], // munch name skeleton screen width %, munch members screen width %, munch status screen width %
      [0.4, 0.2, 0.3],
      [0.6, 0.3, 0.4]
  ];

  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Palette.secondaryLight.withOpacity(0.7),
      highlightColor: Palette.secondaryLight.withOpacity(0.45),
      child: Container(
          height: 72.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _munchLeading(),
              SizedBox(width: 16.0),
              Expanded(child: _munchInfo()),
              SizedBox(width: 12.0),
              _munchTrailing()
            ],
          )
      )
    );
  }

  Widget _munchLeading(){
    return AspectRatio(
      aspectRatio: 1,
      child: CircleAvatar(backgroundColor: Palette.secondaryLight.withOpacity(0.5)),
    );
  }

  Widget _munchInfo(){
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: App.screenWidth * _skeletonScreenWidthPercentages[index % 3][0],
            height: 16.0,
            color: Palette.secondaryLight.withOpacity(0.5),
          ),
          Container(
            width: App.screenWidth * _skeletonScreenWidthPercentages[index % 3][1],
            height: 16.0,
            color: Palette.secondaryLight.withOpacity(0.5),
          ),
          Container(
            width: App.screenWidth * _skeletonScreenWidthPercentages[index % 3][2],
            height: 16.0,
            color: Palette.secondaryLight.withOpacity(0.5),
          )
        ]
    );
  }

  Widget _munchTrailing(){
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 4.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 24.0,
                height: 8.0,
                color: Palette.secondaryLight.withOpacity(0.5),
              ),
            ],
          )
        ]
    );
  }
}