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

class MunchListWidgetSkeleton extends StatefulWidget {
  Munch munch;

  MunchListWidgetSkeleton({this.munch});

  @override
  State<MunchListWidgetSkeleton> createState() => _MunchListWidgetSkeletonState();
}

class _MunchListWidgetSkeletonState extends State<MunchListWidgetSkeleton> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Animation _gradientPosition;

  @override
  void initState() {
    _controller = AnimationController(duration: Duration(milliseconds: 1000), vsync: this);

    _gradientPosition = Tween<double>(
      begin: -3,
      end: 10,
    ).animate(
      CurvedAnimation(
          parent: _controller,
          curve: Curves.linear
      ),
    )..addListener(() {
      setState(() {});
    });

    _controller.repeat();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Palette.secondaryLight.withOpacity(0.7),
      highlightColor: Palette.secondaryLight.withOpacity(0.3),
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
            width: 120.0,
            height: 16.0,
            color: Palette.secondaryLight.withOpacity(0.5),
          ),
          Container(
            width: 60.0,
            height: 16.0,
            color: Palette.secondaryLight.withOpacity(0.5),
          ),
          Container(
            width: 80.0,
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