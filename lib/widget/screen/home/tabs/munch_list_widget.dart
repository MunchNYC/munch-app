import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';

class MunchListWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        // TODO: Navigate to munch
      },
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
      child: CircleAvatar(backgroundImage: AssetImage('assets/images/prototype/sushi1.jpg')),
    );
  }

  Widget _munchInfo(){
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("The Crew", style: AppTextStyle.style(AppTextStylePattern.body3), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text("5 members", style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.secondaryLight, fontSizeOffset: 1.0)),
          Text("Undecided", style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.secondaryLight, fontSizeOffset: 1.0)),
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
              Text("Mar 23", style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.secondaryLight)),
              Icon(Icons.navigate_next, color: Palette.secondaryLight, size: 14.0)
            ],
          )
        ]
    );
  }
}