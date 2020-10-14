import 'package:flutter/material.dart';
import 'package:munch/config/constants.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/model/restaurant.dart';
import 'package:munch/theme/dimensions.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/navigation_helper.dart';
import 'package:munch/widget/screen/swipe/include/tutorial_restaurant_card.dart';
import 'package:munch/widget/screen/swipe/restaurant_swipe_screen.dart';
import 'package:munch/widget/util/invisible_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialRestaurantSwipeScreen extends StatefulWidget {
  Munch munch;
  Restaurant restaurant;
  TutorialState tutorialState;

  TutorialRestaurantSwipeScreen({this.munch, this.restaurant, this.tutorialState});

  @override
  State<TutorialRestaurantSwipeScreen> createState() {
    return _TutorialRestaurantSwipeScreenState();
  }
}

class _TutorialRestaurantSwipeScreenState extends State<TutorialRestaurantSwipeScreen> {
  void _onScreenTapped() async{
    setState(() {
      widget.tutorialState = TutorialState.values[widget.tutorialState.index + 1];
    });

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(StorageKeys.SWIPE_TUTORIAL_STATE, widget.tutorialState.index);

    if(widget.tutorialState == TutorialState.FINISHED){
      // pop overlay dialog
      NavigationHelper.popRoute(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: _onScreenTapped,
        child: Scaffold(
            appBar: AppBar(backgroundColor: Colors.transparent, automaticallyImplyLeading: false,elevation: 0.0),
            backgroundColor: Colors.transparent,
            body: Container(
                width: double.infinity,
                height: double.infinity,
                padding: AppDimensions.padding(AppPaddingType.screenWithAppBar).copyWith(top: 8.0, left: 0.0, right: 0.0),
                child: _renderScreen(context)
            )
        )
    );
  }

  Widget _renderScreen(BuildContext context){
    return Column(
        children: [
          Expanded(
              child: Container(
                  child: _draggableCard(),
                  padding: EdgeInsets.symmetric(horizontal: 8.0)
              )
          ),
          SizedBox(height: 8.0),
          InvisibleWidget(child: Divider(height: 1.0, thickness: 2.0, color: Palette.secondaryLight.withOpacity(0.7))),
          Padding(
              padding: EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 16.0),
              child: InvisibleWidget(child: _decisionInfoBar())
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
            TutorialRestaurantCard(widget.restaurant, widget.tutorialState),
            if(widget.tutorialState == TutorialState.TUTORIAL_SWIPE)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: Palette.background, width: 2.0)
                )
            )
          ]
        ),
    );
  }

  Widget _decisionInfoBar(){
    return SafeArea(
        top: false,
        right: false,
        left: false,
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
