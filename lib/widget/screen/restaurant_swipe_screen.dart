import 'package:flutter/material.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/util/navigation_helper.dart';
import 'package:munch/widget/include/restaurant_card.dart';

class RestaurantSwipeScreen extends StatefulWidget {
  Munch munch;

  // will be true if we need to call back-end to get detailed munch instead of compact
  bool shouldRefreshMunch;

  RestaurantSwipeScreen({this.munch, this.shouldRefreshMunch = false});

  @override
  State<StatefulWidget> createState() {
    return _RestaurantSwipeScreenState();
  }
}

class _RestaurantSwipeScreenState extends State<RestaurantSwipeScreen> {
  List<Widget> cardList;

  void _removeCard(index) {
    setState(() {
      cardList.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    cardList = _getCards();
  }

  Future<bool> _onWillPopScope(BuildContext context) async {
    // return result to previous route, in order to refresh things
    NavigationHelper.popRoute(context, rootNavigator: true, result: widget.munch);

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPopScope(context),
      child: Scaffold(
          backgroundColor: Colors.grey[100],
          body: SafeArea(
            child: Column(children: [
              Expanded(
                  child: Container(
                      child: RestaurantCard(),
                      padding: EdgeInsets.only(left: 24, top: 24, right: 24)
                  )),
            ]),
          )
    ));
  }

  List<Widget> _getCards() {
    // Get Restaurants Here
    List<RestaurantCard> cards = new List();
    cards.add(RestaurantCard());
    cards.add(RestaurantCard());
    cards.add(RestaurantCard());

    List<Widget> cardList = new List();

    RestaurantCard getNextCard(index) {
      if (index + 1 == cards.length) {
        return null;
      } else {
        return cards[index];
      }
    }

    for (int x = 0; x < cards.length; x++) {
      cardList.add(Draggable(
        onDragEnd: (drag) {
          _removeCard(x);
        },
        child: cards[x],
        feedback: cards[x],
        childWhenDragging: getNextCard(x),
      ));
    }

    return cardList;
  }
}
