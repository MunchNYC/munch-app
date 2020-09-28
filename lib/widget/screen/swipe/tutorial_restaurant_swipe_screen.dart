import 'package:flutter/material.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/model/restaurant.dart';
import 'package:munch/theme/dimensions.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/widget/screen/swipe/include/tutorial_restaurant_card.dart';

class TutorialRestaurantSwipeScreen extends StatefulWidget {
  Munch munch;
  Restaurant restaurant;

  TutorialRestaurantSwipeScreen({this.munch, this.restaurant});

  @override
  State<TutorialRestaurantSwipeScreen> createState() {
    return _TutorialRestaurantSwipeScreenState();
  }
}

class _TutorialRestaurantSwipeScreenState extends State<TutorialRestaurantSwipeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(backgroundColor: Colors.transparent, automaticallyImplyLeading: false,elevation: 0.0),
          backgroundColor: Colors.transparent,
          body: Container(
              width: double.infinity,
              height: double.infinity,
              padding: AppDimensions.padding(AppPaddingType.screenWithAppBar).copyWith(left: 0.0, right: 0.0),
              child: _renderScreen(context)
          )
    );
  }


  Widget _renderScreen(BuildContext context){
    return Column(
        children: [
          Expanded(
              child: Container(
                  child: _draggableCard(),
                  padding: EdgeInsets.symmetric(horizontal: 24.0)
              )
          ),
          SizedBox(height: 16.0),
          Visibility(visible: false, maintainAnimation: true, maintainState: true, maintainSize: true, child: Divider(height: 16.0, thickness: 2.0, color: Palette.secondaryLight.withOpacity(0.7))),
          Padding(
              padding: EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 16.0),
              child: Visibility(visible: false, maintainState: true, maintainAnimation: true, maintainSize: true, child: _decisionInfoBar())
          )
        ]
    );
  }

  /*
    must be wrapped inside layout builder,
    otherwise feedback widget won't work, width and height of it should be defined, because feedback cannot see Expanded widget above
  */
  Widget _draggableCard(){
    return LayoutBuilder(
      builder: (context, constraints) =>
        Stack(
          children:[
              TutorialRestaurantCard(widget.restaurant),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: Palette.background, width: 2.0)
                ),
              )
          ]
        ),
    );
  }

  Widget _decisionInfoBar(){
    return SafeArea(
        child:Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Text(widget.munch.munchStatus == MunchStatus.UNDECIDED ?
              App.translate("restaurant_swipe_screen.munch_status.undecided.action_message.text") :
              App.translate("restaurant_swipe_screen.munch_status.decided.action_message.text"),
                  style: AppTextStyle.style(AppTextStylePattern.body3, fontSizeOffset: 1.0, fontWeight: FontWeight.w500)
              ),
            ),
            Expanded(
                child: Material(
                    elevation: widget.munch.munchStatus == MunchStatus.UNDECIDED ? 0.0 : 4.0,
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                      decoration: BoxDecoration(
                          color: widget.munch.munchStatus == MunchStatus.UNDECIDED ? Palette.background : Palette.secondaryDark,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              width: 1.0,
                              color: Palette.secondaryDark
                          )
                      ),
                      child: Center(
                          child: widget.munch.munchStatus == MunchStatus.UNDECIDED ?
                          Text(App.translate("restaurant_swipe_screen.munch_status.undecided.status.text"),
                              style: AppTextStyle.style(AppTextStylePattern.body3,
                                  color:  Palette.primary,
                                  fontSizeOffset: 1.0,
                                  fontWeight: FontWeight.w500
                              ),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis
                          )
                          : Text(widget.munch.matchedRestaurant.name,
                              style: AppTextStyle.style(AppTextStylePattern.body3,
                                  color: Palette.background,
                                  fontSizeOffset: 1.0,
                                  fontWeight: FontWeight.w500
                              ),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.clip
                          )
                      ),
                    )
                )
            )
          ],
        )
    );
  }
}
