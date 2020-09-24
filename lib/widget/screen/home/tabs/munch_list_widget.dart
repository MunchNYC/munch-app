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

class MunchListWidget extends StatelessWidget {
  Munch munch;

  MunchListWidget({this.munch});


  Widget build(BuildContext context) {
    return Container(
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
    );
  }

  Widget _munchLeading(){
    return AspectRatio(
      aspectRatio: 1,
      child: CircleAvatar(backgroundImage: AssetImage('assets/images/logo/logo_BG_Red.png')),
    );
  }

  Widget _munchInfo(){
    return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(munch.name, style: AppTextStyle.style(AppTextStylePattern.body3),
                maxLines: 1,
                overflow: TextOverflow.ellipsis
            ),
            Text(munch.numberOfMembers.toString() + " " + App.translate("munch_list_widget.members.text"), style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.secondaryLight, fontSizeOffset: 1.0)),
            Text(munch.munchStatus == MunchStatus.UNDECIDED ? App.translate("munch_list_widget.munch_status.undecided.text") : munch.matchedRestaurantName, style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.secondaryLight, fontSizeOffset: 1.0),
                maxLines: 2,
                overflow: TextOverflow.ellipsis
            ),
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
              Text(DateFormat('MMM dd').format(munch.creationTimestamp), style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.secondaryLight)),
              Icon(Icons.navigate_next, color: Palette.secondaryLight, size: 14.0)
            ],
          )
        ]
    );
  }
}