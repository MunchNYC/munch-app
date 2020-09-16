import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:munch/model/restaurant.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';

class RestaurantCard extends StatefulWidget {
  Restaurant restaurant;

  RestaurantCard(this.restaurant): super(key: Key(restaurant.id));

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
      borderRadius: BorderRadius.circular(16.0),
      color: Colors.white,
      child: Column(
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

  Widget _titleSection(){
    return Container(
      padding: EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.restaurant.name, style: AppTextStyle.style(AppTextStylePattern.heading2, fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image(image: AssetImage("assets/images/yelp/yelp-burst.png"), height: 16.0),
              SizedBox(width: 8.0),
              _starsRating(),
              SizedBox(width: 8.0),
              Text('69 Reviews', style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.secondaryLight)),
            ],
          ),
          SizedBox(height: 8.0),
          Text(widget.restaurant.priceSymbol + ' • Japanese', style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.secondaryLight)),
          SizedBox(height: 8.0),
          Text('Open until 11:30 pm', style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.secondaryLight)),
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
                initialPage: widget.currentCarouselPage
              ),
              carouselController: _carouselController,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(child: GestureDetector(child: Container(color: Colors.transparent),
                    onTap: (){ _carouselController.previousPage(); widget.currentCarouselPage --; if(widget.currentCarouselPage < 0) widget.currentCarouselPage = 2;})),
                Expanded(child: GestureDetector(child: Container(color: Colors.transparent),
                    onTap: (){ _carouselController.nextPage();  widget.currentCarouselPage ++; if(widget.currentCarouselPage > 2) widget.currentCarouselPage = 0; })),
              ]
            )
        ]
      )
     )
    );
  }
}
