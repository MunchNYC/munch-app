import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget titleSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 20),
        Container(
            child: Text('Tetsu Sushi', style: TextStyle(fontSize: 32)),
            padding: EdgeInsets.only(left: 24)),
        SizedBox(height: 8),
        Padding(
            padding: EdgeInsets.only(left: 24),
            child: Row(
              children: <Widget>[
                Text('Yelp Logo'),
                Icon(Icons.star, color: Colors.amber[600], size: 20),
                Icon(Icons.star, color: Colors.amber[600], size: 20),
                Icon(Icons.star, color: Colors.amber[600], size: 20),
                Icon(Icons.star_half, color: Colors.amber[600], size: 20),
                Icon(Icons.star_border, color: Colors.amber[600], size: 20)
              ],
            )),
        Container(
            padding:
                const EdgeInsets.only(left: 24, top: 8, right: 16, bottom: 16),
            child: Text(
              '\$\$\$\$ • Japanese',
              softWrap: true,
            )),
      ],
    );

    Widget imageCarousel = Expanded(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18)),
          child: Image.asset('images/sushi1.jpg',
              fit: BoxFit.cover, width: constraints.maxWidth - 2),
        );
      }),
    );

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18), color: Colors.white),
      child: Column(children: <Widget>[
        titleSection,
        imageCarousel,
      ]),
    );
  }
}
