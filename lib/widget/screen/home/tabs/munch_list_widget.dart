import 'package:calendar_time/calendar_time.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/theme/dimensions.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';

class MunchListWidget extends StatelessWidget {
  Munch munch;

  MunchListWidget({this.munch});

  Widget build(BuildContext context) {
    return Container(
        height: AppDimensions.scaleSizeToScreen(88.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _munchLeading(),
            SizedBox(width: 16.0),
            Expanded(child: _munchInfo()),
          ],
        ));
  }

  Widget _munchLeading() {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: CircleAvatar(backgroundImage: NetworkImage(munch.imageUrl)),
        ),
        if (munch.munchStatusChanged && munch.munchStatus == MunchStatus.DECIDED)
          Positioned(
            top: 0.0,
            right: 0.0,
            child: Icon(Icons.circle, color: Color(0xFFE60000), size: AppDimensions.scaleSizeToScreen(12.0)),
          )
      ],
    );
  }

  Widget _munchInfo() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _groupNameAndDateRow(),
          _restaurantNameRow(),
          _numberOfMembersRow(),
        ]);
  }

  String _formatCreationTimestamp(DateTime creationTimestamp) {
    CalendarTime calendarTime = CalendarTime(creationTimestamp);

    String formattedTimestamp;

    if (calendarTime.isToday) {
      formattedTimestamp = App.translate("munch_list_widget.creation_timestamp.today.text");
    } else if (calendarTime.isYesterday) {
      formattedTimestamp = App.translate("munch_list_widget.creation_timestamp.yesterday.text");
    } else if (calendarTime.isTomorrow) {
      formattedTimestamp = App.translate("munch_list_widget.creation_timestamp.tomorrow.text");
    } else {
      formattedTimestamp = calendarTime.format('MMM dd');
    }

    return formattedTimestamp;
  }

  Widget _groupNameAndDateRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
            child: Text(munch.name,
                style: AppTextStyle.style(AppTextStylePattern.body3), maxLines: 1, overflow: TextOverflow.ellipsis)),
        SizedBox(width: 8.0),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(_formatCreationTimestamp(munch.creationTimestamp),
                style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.secondaryLight)),
            Icon(Icons.navigate_next, color: Palette.secondaryLight.withOpacity(0.6), size: 16.0)
          ],
        ),
      ],
    );
  }

  Widget _restaurantNameRow() {
    return
      (munch.munchStatus == MunchStatus.UNDECIDED)
          ?
      Text(App.translate("munch_list_widget.munch_status.undecided.text"),
          style: AppTextStyle.style(AppTextStylePattern.body3, color: Palette.secondaryLight, fontSizeOffset: 1.0),
          maxLines: 1,
          overflow: TextOverflow.ellipsis)
          :
      Text(munch.matchedRestaurantName,
          style:
          AppTextStyle.style(AppTextStylePattern.body3, color: Palette.secondaryLight, fontSizeOffset: 1.0),
          maxLines: 1,
          overflow: TextOverflow.ellipsis);
  }

  Widget _numberOfMembersRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
            child: Text(munch.getNumberOfMembers().toString() + " " + App.translate("munch_list_widget.members.text"),
                style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.secondaryLight, fontSizeOffset: 1.0))),
        if (munch.munchStatus == MunchStatus.DECIDED) SizedBox(width: 8.0),
        if (munch.munchStatus == MunchStatus.DECIDED)
          Padding(
              padding: EdgeInsets.only(right: 4.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.navigate_before, color: Palette.secondaryLight.withOpacity(0.6), size: 16.0),
                  Text(App.translate("munch_list_widget.swipe_to_review.text"),
                      style: AppTextStyle.style(AppTextStylePattern.body, color: Palette.secondaryLight),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  SizedBox(width: 4.0),
                  ImageIcon(AssetImage("assets/icons/leaveReview.png"), color: Palette.primary, size: 16.0),
                ],
              )),
      ],
    );
  }
}
