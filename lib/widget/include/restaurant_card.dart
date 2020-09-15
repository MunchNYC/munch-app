import 'package:flutter/material.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';

class RestaurantCard extends StatelessWidget {
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

  Widget _titleSection(){
    return Container(
      padding: EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Tetsu Sushi', style: AppTextStyle.style(AppTextStylePattern.heading2, fontWeight: FontWeight.w500)),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image(image: AssetImage("assets/images/yelp/yelp-burst.png"), height: 16.0),
              SizedBox(width: 8.0),
              Image(image: AssetImage("assets/images/yelp/stars/stars_regular_4_half.png"), height: 16.0),
              SizedBox(width: 8.0),
              Text('69 Reviews', style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.secondaryLight)),
            ],
          ),
          SizedBox(height: 8.0),
          Text('\$\$\$\$ • Japanese', style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.secondaryLight)),
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
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18)
        ),
        child: Image.asset('assets/images/prototype/sushi1.jpg', fit: BoxFit.cover),
      )
    );
  }
}
