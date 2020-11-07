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

class ReviewMunchDialog extends StatelessWidget{
  MunchBloc munchBloc;
  Munch munch;
  String imageUrl;
  bool forcedReview;

  ReviewMunchDialog({this.munchBloc, this.munch, this.imageUrl, this.forcedReview = false});

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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              // must be set here otherwise container will take full height in dialog
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(bottom: 16.0),
                      decoration: BoxDecoration(
                        color: Palette.background,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                              color: Palette.primary.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 3
                          ),
                        ],
                      ),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              height: 0.25 * App.screenHeight,
                              child: ClipRRect(
                                  // Radius must be set on image too, not enough in parent
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
                                    child: Image(
                                    image: NetworkImage(munch.imageUrl),
                                    fit: BoxFit.cover,
                                  )
                              ),
                            ),
                            SizedBox(height: 12.0),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.0),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                        Text(munch.matchedRestaurantName, style: AppTextStyle.style(AppTextStylePattern.heading2, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
                                        SizedBox(height: 8.0),
                                        Text(munch.name, style: AppTextStyle.style(AppTextStylePattern.body3, fontWeight: FontWeight.w500)),
                                        Divider(thickness: 2.0, height: 24.0, color: Palette.secondaryLight.withOpacity(0.6)),
                                        SizedBox(height: 6.0),
                                        _likeButton(state),
                                        SizedBox(height: 12.0),
                                        _neutralButton(state),
                                        SizedBox(height: 12.0),
                                        _dislikeButton(state),
                                        SizedBox(height: 20.0),
                                        _didNotGoLabel(state),
                                        SizedBox(height: 20.0),
                                        _skipLabel(state),
                                    ]
                                )
                            )
                          ]
                      )
                  ),
                ]
              )
            )
          );
        }
      );
  }

  Widget _likeButton(MunchState state){
    return CustomButton(
        cubit: munchBloc,
        padding: EdgeInsets.symmetric(vertical: 12.0),
        elevation: 6.0,
        borderRadius: 8.0,
        color: Palette.background,
        textColor: Palette.primary,
        minWidth: App.REF_DEVICE_WIDTH,
        content: Text(App.translate("review_munch_dialog.liked_button.text"), style: AppTextStyle.style(AppTextStylePattern.heading5, fontWeight: FontWeight.w500)),
        onPressedCallback: (){
          munchBloc.add(ReviewMunchEvent(munchReviewValue: MunchReviewValue.LIKED, munchId: munch.id, forcedReview: forcedReview));
        },
    );
  }

  Widget _neutralButton(MunchState state){
    return CustomButton(
        cubit: munchBloc,
        padding: EdgeInsets.symmetric(vertical: 12.0),
        elevation: 6.0,
        borderRadius: 8.0,
        color: Palette.background,
        textColor: Palette.primary,
        minWidth: App.REF_DEVICE_WIDTH,
        content: Text(App.translate("review_munch_dialog.neutral_button.text"), style: AppTextStyle.style(AppTextStylePattern.heading5, fontWeight: FontWeight.w500)),
        onPressedCallback: (){
          munchBloc.add(ReviewMunchEvent(munchReviewValue: MunchReviewValue.NEUTRAL, munchId: munch.id, forcedReview: forcedReview));
        },
    );
  }


  Widget _dislikeButton(MunchState state){
    return CustomButton(
        cubit: munchBloc,
        padding: EdgeInsets.symmetric(vertical: 12.0),
        elevation: 6.0,
        borderRadius: 8.0,
        color: Palette.background,
        textColor: Palette.primary,
        minWidth: App.REF_DEVICE_WIDTH,
        content: Text(App.translate("review_munch_dialog.disliked_button.text"),style: AppTextStyle.style(AppTextStylePattern.heading5, fontWeight: FontWeight.w500)),
        onPressedCallback: (){
          munchBloc.add(ReviewMunchEvent(munchReviewValue: MunchReviewValue.DISLIKED, munchId: munch.id, forcedReview: forcedReview));
        },
    );
  }


  Widget _didNotGoLabel(MunchState state){
    return CustomButton(
      cubit: munchBloc,
      padding: EdgeInsets.zero,
      color: Colors.transparent,
      textColor: Palette.secondaryDark,
      flat: true,
      content: Text(App.translate("review_munch_dialog.did_not_go_label.text"), style: AppTextStyle.style(AppTextStylePattern.heading6SecondaryDark, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
      onPressedCallback: (){
        munchBloc.add(ReviewMunchEvent(munchReviewValue: MunchReviewValue.NOSHOW, munchId: munch.id, forcedReview: forcedReview));
      },
    );
  }

  Widget _skipLabel(MunchState state){
    return CustomButton(
      cubit: munchBloc,
      padding: EdgeInsets.zero,
      color: Colors.transparent,
      textColor: Palette.secondaryLight,
      flat: true,
      content: Text(App.translate("review_munch_dialog.skip_label.text"), style: AppTextStyle.style(AppTextStylePattern.body2, fontSizeOffset: 2.0, color: Palette.secondaryLight), textAlign: TextAlign.center),
      onPressedCallback: (){
        munchBloc.add(ReviewMunchEvent(munchReviewValue: MunchReviewValue.SKIPPED, munchId: munch.id, forcedReview: forcedReview));
      },
    );
  }
}