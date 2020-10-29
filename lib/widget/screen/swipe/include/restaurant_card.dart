import 'package:animator/animator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:munch/model/restaurant.dart';
import 'package:munch/service/munch/munch_bloc.dart';
import 'package:munch/service/munch/munch_event.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/utility.dart';

class RestaurantCard extends StatefulWidget {
  Restaurant restaurant;
  MunchBloc munchBloc;

  RestaurantCard(this.restaurant, {this.munchBloc}): super(key: Key(restaurant.id));

  // must be saved here, because of Dragging purposes. Otherwise we cannot keep same image as it was when drag started
  int currentCarouselPage = 0;

  @override
  _RestaurantCardState createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard>{
  // Must be instantiated here to be always created again when drag starts, otherwise we'll get exceptions because carousel controller won't be instantiated again when we start dragging
  CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8.0,
      // must be transparent otherwise we'll have Z-axis fight below the image, slight colored line will be there if Material has defined color
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _titleSection(),
          Expanded(
            child: _imageCarousel()
          )
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
      padding: EdgeInsets.only(top: 24.0, bottom: 16.0, left: 16.0, right: 16.0),
      decoration: BoxDecoration(
        color: Palette.background,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0)
        )
      ),
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
     decoration: BoxDecoration(
         color: Palette.background, // this is duplicated in order to show background while we're  waiting for image to be rendered
         borderRadius: BorderRadius.only(
             bottomLeft: Radius.circular(16.0),
             bottomRight: Radius.circular(16.0)
         )
     ),
     child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0)
        ),
        child: Stack(
          children: [
            CarouselSlider(
              items: widget.restaurant.photoUrls.map((photoUrl) =>
                SizedBox(
                  width: double.infinity,
                  child: Image(image: NetworkImage(photoUrl), fit: BoxFit.cover),
                )
              ).toList(),
              options: CarouselOptions(
                height: double.infinity,
                autoPlay: false,
                enlargeCenterPage: false,
                viewportFraction: 1.0,
                scrollPhysics: NeverScrollableScrollPhysics(),
                initialPage: widget.currentCarouselPage,
                enableInfiniteScroll: false
              ),
              carouselController: _carouselController,
            ),
            _carouselControlsRow()
        ]
      )
     )
    );
  }

  void _onCarouselLeftSideTapped(){
    if(widget.currentCarouselPage - 1 >= 0){
      widget.currentCarouselPage--;
      _carouselController.previousPage();
    } else{
      widget.munchBloc.add(NoMoreImagesCarouselEvent(isLeftSideTapped: true));
    }
  }

  void _onCarouselRightHalfTapped(){
    if(widget.currentCarouselPage + 1 < widget.restaurant.photoUrls.length){
      widget.currentCarouselPage++;
      _carouselController.nextPage();
    } else{
      widget.munchBloc.add(NoMoreImagesCarouselEvent(isLeftSideTapped: false));
    }
  }

  Widget _carouselControlsRow(){
    return Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(child: GestureDetector(
              child: Container(color: Colors.transparent),
              onTap: _onCarouselLeftSideTapped
            )
          ),
          Expanded(child: GestureDetector(
              child: Container(color: Colors.transparent),
              onTap: _onCarouselRightHalfTapped
            )
          ),
        ]
    );
  }
}
