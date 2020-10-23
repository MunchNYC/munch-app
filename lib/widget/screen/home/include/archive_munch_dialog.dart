import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return BlocBuilder<MunchBloc, MunchState>(
        cubit: munchBloc,
        buildWhen: (MunchState previous, MunchState current) => current is ReviewMunchState,
        builder: (BuildContext context, MunchState state) {
          return WillPopScope(
            onWillPop: () async {
              // Prevent closing of Dialog when request is sending, because we're closing popup outside of the dialog
              if(state is ReviewMunchState && state.loading){
                return false;
              } else{
                return true;
              }
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(munch.matchedRestaurantName,
                          style: AppTextStyle.style(
                              AppTextStylePattern.heading2,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center),
                      SizedBox(height: 6.0),
                      Text(munch.name,
                          style: AppTextStyle.style(AppTextStylePattern.body3,
                              fontWeight: FontWeight.w500)),
                      Divider(thickness: 2.0,
                          height: 24.0,
                          color: Palette.secondaryLight.withOpacity(0.6)),
                      SizedBox(height: 6.0),
                      _likeButton(state),
                      SizedBox(height: 12.0),
                      _neutralButton(state),
                      SizedBox(height: 12.0),
                      _dislikeButton(state),
                      SizedBox(height: 20.0),
                      _didNotGoLabel(state)
                    ]
                )
            ),
          );
        }
      );
  }

  Widget _likeButton(MunchState state){
    print("LIKE STATE " + state.toString());
    return CustomButton<MunchState, ReviewMunchState>.bloc(
        cubit: munchBloc,
        padding: EdgeInsets.symmetric(vertical: 12.0),
        elevation: 6.0,
        borderRadius: 8.0,
        color: Palette.background,
        textColor: Palette.primary,
        minWidth: App.REF_DEVICE_WIDTH,
        disabled: state is ReviewMunchState && state.loading && state.munchReviewValue != MunchReviewValue.LIKED,
        content: Text(App.translate("archive_munch_dialog.liked_button.text"), style: AppTextStyle.style(AppTextStylePattern.heading5, fontWeight: FontWeight.w500)),
        onPressedCallback: (){
          munchBloc.add(ReviewMunchEvent(munchReviewValue: MunchReviewValue.LIKED, munchId: munch.id));
        },
        additionalLoadingConditionCallback: (state){
          ReviewMunchState reviewMunchState = state as ReviewMunchState;
          return reviewMunchState.munchReviewValue == MunchReviewValue.LIKED;
        },
    );
  }

  Widget _neutralButton(MunchState state){
    return CustomButton<MunchState, ReviewMunchState>.bloc(
        cubit: munchBloc,
        padding: EdgeInsets.symmetric(vertical: 12.0),
        elevation: 6.0,
        borderRadius: 8.0,
        color: Palette.background,
        textColor: Palette.primary,
        minWidth: App.REF_DEVICE_WIDTH,
        disabled: state is ReviewMunchState && state.loading && state.munchReviewValue != MunchReviewValue.NEUTRAL,
        content: Text(App.translate("archive_munch_dialog.neutral_button.text"), style: AppTextStyle.style(AppTextStylePattern.heading5, fontWeight: FontWeight.w500)),
        onPressedCallback: (){
          munchBloc.add(ReviewMunchEvent(munchReviewValue: MunchReviewValue.NEUTRAL, munchId: munch.id));
        },
        additionalLoadingConditionCallback: (state){
          ReviewMunchState reviewMunchState = state as ReviewMunchState;

          return reviewMunchState.munchReviewValue == MunchReviewValue.NEUTRAL;
        },
    );
  }


  Widget _dislikeButton(MunchState state){
    return CustomButton<MunchState, ReviewMunchState>.bloc(
        cubit: munchBloc,
        padding: EdgeInsets.symmetric(vertical: 12.0),
        elevation: 6.0,
        borderRadius: 8.0,
        color: Palette.background,
        textColor: Palette.primary,
        minWidth: App.REF_DEVICE_WIDTH,
        disabled: state is ReviewMunchState && state.loading && state.munchReviewValue != MunchReviewValue.DISLIKED,
        content: Text(App.translate("archive_munch_dialog.disliked_button.text"),style: AppTextStyle.style(AppTextStylePattern.heading5, fontWeight: FontWeight.w500)),
        onPressedCallback: (){
          munchBloc.add(ReviewMunchEvent(munchReviewValue: MunchReviewValue.DISLIKED, munchId: munch.id));
        },
        additionalLoadingConditionCallback: (state){
          ReviewMunchState reviewMunchState = state as ReviewMunchState;

          return reviewMunchState.munchReviewValue == MunchReviewValue.DISLIKED;
        },
    );
  }


  Widget _didNotGoLabel(MunchState state){
    return CustomButton<MunchState, ReviewMunchState>.bloc(
      cubit: munchBloc,
      padding: EdgeInsets.zero,
      color: Colors.transparent,
      textColor: Palette.secondaryDark,
      flat: true,
      disabled: state is ReviewMunchState && state.loading && state.munchReviewValue != MunchReviewValue.NOSHOW,
      content: Text(App.translate("archive_munch_dialog.did_not_go_label.text"), style: AppTextStyle.style(AppTextStylePattern.body2SecondaryDark, fontSizeOffset: 2.0), textAlign: TextAlign.center),
      onPressedCallback: (){
        munchBloc.add(ReviewMunchEvent(munchReviewValue: MunchReviewValue.NOSHOW, munchId: munch.id));
      },
      additionalLoadingConditionCallback: (state){
        ReviewMunchState reviewMunchState = state as ReviewMunchState;

        return reviewMunchState.munchReviewValue == MunchReviewValue.NOSHOW;
      },
    );
  }
}