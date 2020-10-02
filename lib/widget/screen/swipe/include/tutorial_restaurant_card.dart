import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munch/model/restaurant.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/utility.dart';
import 'package:munch/widget/screen/swipe/restaurant_swipe_screen.dart';
import 'package:munch/widget/util/invisible_widget.dart';

class TutorialRestaurantCard extends StatefulWidget {
  Restaurant restaurant;
  TutorialState tutorialState;

  TutorialRestaurantCard(this.restaurant, this.tutorialState);

  @override
  _TutorialRestaurantCardState createState() => _TutorialRestaurantCardState();
}

class _TutorialRestaurantCardState extends State<TutorialRestaurantCard>{
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0.0,
      borderRadius: BorderRadius.circular(16.0),
      color: Colors.transparent,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                InvisibleWidget(child: _titleSection()),
                if(widget.tutorialState == TutorialState.TUTORIAL_SWIPE)
                Positioned.fill(child: Center(child:VerticalDivider(thickness: 2.0,color: Palette.background))),
              ],
            ),
            Expanded(
                child: _imageCarousel()
            ),
          ]
      ),
    );
  }

  Widget _starsRating(){
    String afterDecimalPointValue = widget.restaurant.rating.toString().substring(widget.restaurant.rating.toString().indexOf(".") + 1);
    return Image(image: AssetImage("assets/images/yelp/stars/stars_regular_" + widget.restaurant.rating.floor().toString() + (afterDecimalPointValue == "0" ? "" : "_half") + ".png"), height: 16.0);
  }

  Widget _yelpStatsRow(){
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Image(image: AssetImage("assets/images/yelp/yelp-burst.png"), height: 16.0),
          SizedBox(width: 8.0),
          _starsRating(),
          SizedBox(width: 8.0),
          Text(widget.restaurant.reviewsNumber.toString() + ' ' + App.translate('restaurant_swipe_screen.restaurant_card.yelp.reviews.text'), style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.secondaryLight)),
        ],
    );
  }

  Widget _titleSection(){
    return Container(
        padding: EdgeInsets.only(top: 24.0, bottom: 16.0, left: 16.0, right: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.restaurant.name, style: AppTextStyle.style(AppTextStylePattern.heading3, fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis),
            SizedBox(height: 8.0),
            _yelpStatsRow(),
            SizedBox(height: 8.0),
            Text((widget.restaurant.priceSymbol != null ? widget.restaurant.priceSymbol + ' • ' : "") + widget.restaurant.categoryTitles, style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.primary.withOpacity(0.7))),
            SizedBox(height: 8.0),
            Text(widget.restaurant.getWorkingHoursCurrentStatus(), style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.secondaryLight)),
          ],
        )
    );
  }

  Widget _tutorialCarouselTitle(){
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: AppTextStyle.style(AppTextStylePattern.heading2Inverse, fontWeight: FontWeight.w500),
          children: [
            TextSpan(
              text: App.translate("tutorial_restaurant_swipe_screen.tutorial_restaurant_card.carousel_tutorial.title.gesture.text") + " ",
              style: AppTextStyle.style(AppTextStylePattern.heading2Inverse, fontWeight: FontWeight.w600),
            ),
            TextSpan(
              text: App.translate("tutorial_restaurant_swipe_screen.tutorial_restaurant_card.carousel_tutorial.title.gesture.description"),
            )
          ]
        )
    );
  }

  Widget _tutorialCarouselControls(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
              child: Text(App.translate("tutorial_restaurant_swipe_screen.tutorial_restaurant_card.carousel_tutorial.controls.previous_control.text"),
                  style: AppTextStyle.style(AppTextStylePattern.heading6Inverse, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center
              )
          ),
        ),
        SizedBox(height: double.infinity, child: VerticalDivider(thickness: 2.0, color: Palette.background)),
        Expanded(
          child: Center(
              child: Text(App.translate("tutorial_restaurant_swipe_screen.tutorial_restaurant_card.carousel_tutorial.controls.next_control.text"),
                  style: AppTextStyle.style(AppTextStylePattern.heading6Inverse, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center
              )
          ),
        ),
      ],
    );
  }

  Widget _tutorialContainer(){
    return Container(
        decoration: BoxDecoration(
            borderRadius: widget.tutorialState == TutorialState.TUTORIAL_CAROUSEL
                ? BorderRadius.only(
                      bottomLeft: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0)
                  )
                : null, // border radius must be removed if border sides below are not uniform
            border: widget.tutorialState == TutorialState.TUTORIAL_CAROUSEL
                ? Border.all(color: Palette.background, width: 2.0)
                : Border(
                    top: BorderSide(color: Palette.background, width: 0.0),
                    left: BorderSide(color: Palette.background, width: 2.0),
                    right: BorderSide(color: Palette.background, width: 2.0),
                    bottom: BorderSide(color: Palette.background, width: 2.0)
                  )
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  height: 48.0,
                  child: Center(child: VerticalDivider(thickness: 2.0, color: Palette.background))
              ),
              SizedBox(height: 8.0),
              if(widget.tutorialState == TutorialState.TUTORIAL_CAROUSEL) _tutorialCarouselTitle(),
              if(widget.tutorialState == TutorialState.TUTORIAL_SWIPE) _tutorialSwipeTitle(),
              SizedBox(height: 8.0),
              if(widget.tutorialState == TutorialState.TUTORIAL_CAROUSEL) Expanded(child: _tutorialCarouselControls()),
              if(widget.tutorialState == TutorialState.TUTORIAL_SWIPE) Expanded(child: _tutorialSwipeControls()),
            ],
          ),

    );
  }

  Widget _imageCarousel(){
    return Container(
        width: double.infinity,
        child: ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16.0),
                bottomRight: Radius.circular(16.0)
            ),
            child: Stack(
                children: [
                  InvisibleWidget(
                    child: SizedBox(
                      width: double.infinity,
                      child: Image(image: NetworkImage(widget.restaurant.photoUrls[0]), fit: BoxFit.cover),
                    )
                  ),
                  _tutorialContainer(),
               ]
            )
        )
    );
  }


  Widget _tutorialSwipeTitle(){
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            style: AppTextStyle.style(AppTextStylePattern.heading2Inverse, fontWeight: FontWeight.w500),
            children: [
              TextSpan(
                text: App.translate("tutorial_restaurant_swipe_screen.tutorial_restaurant_card.swipe_tutorial.title.gesture.text") + " ",
                style: AppTextStyle.style(AppTextStylePattern.heading2Inverse, fontWeight: FontWeight.w600),
              ),
              TextSpan(
                text: App.translate("tutorial_restaurant_swipe_screen.tutorial_restaurant_card.swipe_tutorial.title.gesture.description"),
              )
            ]
        )
    );
  }

  Widget _tutorialSwipeControls(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(image: AssetImage("assets/images/swipeLeftArrow.png"), fit: BoxFit.cover, width: 60.0,color: Palette.background),
                  SizedBox(height: 8.0),
                  Text(App.translate("tutorial_restaurant_swipe_screen.tutorial_restaurant_card.swipe_tutorial.controls.left.text"),
                      style: AppTextStyle.style(AppTextStylePattern.heading6Inverse, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center
                  )
                ],
              )
          ),
        ),
        SizedBox(height: double.infinity, child: VerticalDivider(thickness: 2.0, color: Palette.background)),
        Expanded(
          child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(image: AssetImage("assets/images/swipeRightArrow.png"), fit: BoxFit.cover, width: 60.0,color: Palette.background),
                  SizedBox(height: 8.0),
                  Text(App.translate("tutorial_restaurant_swipe_screen.tutorial_restaurant_card.swipe_tutorial.controls.right.text"),
                      style: AppTextStyle.style(AppTextStylePattern.heading6Inverse, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center
                  )
                ],
              )
          ),
        ),
      ],
    );
  }


}
