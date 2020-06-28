import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MunchCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget titleSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 20),
        Container(child: Text('Otaku Katsu', style: TextStyle(fontSize: 24))),
        SizedBox(height: 8),
        Row(children: <Widget>[
          Text('Google Logo'),
          Icon(Icons.star, color: Colors.yellowAccent[700], size: 20),
          Icon(Icons.star, color: Colors.yellowAccent[700], size: 20),
          Icon(Icons.star, color: Colors.yellowAccent[700], size: 20),
          Icon(Icons.star, color: Colors.yellowAccent[700], size: 20),
          Icon(Icons.star_border, color: Colors.yellowAccent[700], size: 20)
        ]),
        Container(
            padding:
                const EdgeInsets.only(left: 0, top: 8, right: 12, bottom: 16),
            child: Text(
              'Cozy Japanese restaurant in the Lower East Side of Manhattan offerring Katsu, Sandos (Sandwiches), Onigiri, Seasonal Dishes, and other Japanese Comfort Food.',
              softWrap: true,
            ))
      ],
    );

    Widget imageCarousel = Container(
        color: Colors.white,
        child: CarouselSlider(
          options: CarouselOptions(
              height: MediaQuery.of(context).size.height / 2,
              enableInfiniteScroll: false,
              enlargeCenterPage: true,
              viewportFraction: 1),
          items: [
            /**
         * Images from backend go here
         */
            Image.asset('images/sushi1.jpg', fit: BoxFit.cover),
            Image.asset('images/sushi2.jpg', fit: BoxFit.cover),
            Image.asset('images/sushi3.jpg', fit: BoxFit.cover),
            Image.asset('images/sushi4.jpg', fit: BoxFit.cover),
            Image.asset('images/sushi5.jpg', fit: BoxFit.cover),
          ].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(12), child: i));
              },
            );
          }).toList(),
        ));

    SafeArea cardWithSafeArea = SafeArea(child: Column(children: <Widget>[
      titleSection,
      imageCarousel,
      SizedBox(height: 40)
    ]));

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24), color: Colors.red[200]),
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: cardWithSafeArea,
    );
  }
}
