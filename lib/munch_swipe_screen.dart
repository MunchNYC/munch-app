import 'package:flutter/material.dart';
import 'package:munch/munch_card.dart';

class MunchSwipeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MunchSwipeScreenState();
  }

}

class _MunchSwipeScreenState extends State<MunchSwipeScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: cardList,
        ),
      ),
    );
  }

  List<Widget> _getCards() {
    // Get Resties Here
    List<MunchCard> cards = new List();
    cards.add(MunchCard());
    cards.add(MunchCard());
    cards.add(MunchCard());

    List<Widget> cardList = new List();

    MunchCard getNextCard(index) {
      if (index + 1 == cards.length) {
        return null;
      } else {
        return cards[index];
      }
    }

    for (int x = 0; x < cards.length; x++) {
      cardList.add(
        Draggable(
          onDragEnd: (drag) {
            _removeCard(x);
          },
        child: cards[x],
        feedback: cards[x],
        childWhenDragging: getNextCard(x),
        )
      );
    }

    return cardList;
  }
}