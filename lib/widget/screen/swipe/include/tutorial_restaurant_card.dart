import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:munch/model/restaurant.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/utility.dart';

class TutorialRestaurantCard extends StatefulWidget {
  Restaurant restaurant;

  TutorialRestaurantCard(this.restaurant);

  @override
  _TutorialRestaurantCardState createState() => _TutorialRestaurantCardState();
}

class _TutorialRestaurantCardState extends State<TutorialRestaurantCard>{
  // Must be instantiated here to be always created again when drag starts, otherwise we'll get exceptions because carousel controller won't be instantiated again when we start dragging
  CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0.0,
      borderRadius: BorderRadius.circular(16.0),
      color: Colors.transparent,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Visibility(visible: false, maintainState: true, maintainAnimation: true, maintainSize: true, child: _titleSection()),
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
    return GestureDetector(
        onTap: (){
          Utility.launchUrl(context, widget.restaurant.url);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image(image: AssetImage("assets/images/yelp/yelp-burst.png"), height: 16.0),
            SizedBox(width: 8.0),
            _starsRating(),
            SizedBox(width: 8.0),
            Text(widget.restaurant.reviewsNumber.toString() + ' ' + App.translate('restaurant_swipe_screen.restaurant_card.yelp.reviews.text'), style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.secondaryLight)),
          ],
        )
    );
  }

  Widget _titleSection(){
    return Container(
        padding: EdgeInsets.all(24.0),
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
                Visibility(visible: false, maintainState: true, maintainAnimation: true, maintainSize: true, child:
                  SizedBox(
                    width: double.infinity,
                    child: Image(image: NetworkImage(widget.restaurant.photoUrls[0]), fit: BoxFit.cover),
                  )),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16.0),
                            bottomRight: Radius.circular(16.0)
                        ),
                        border: Border.all(color: Palette.background, width: 2.0)
                    ),
                  )
                ],
            )
        )
    );
  }

}
