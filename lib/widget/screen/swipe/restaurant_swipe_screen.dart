import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/service/munch/munch_bloc.dart';
import 'package:munch/theme/dimensions.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
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

  MunchBloc _munchBloc;

  void _removeCard(index) {
    setState(() {
      cardList.removeAt(index);
    });
  }

  @override
  void initState() {
    _munchBloc = MunchBloc();

    cardList = _getCards();

    super.initState();
  }

  @override
  void dispose() {
    _munchBloc?.close();

    super.dispose();
  }

  Widget _appBarTitle(){
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(widget.munch.name,
          style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(widget.munch.numberOfMembers.toString(),
              style: AppTextStyle.style(AppTextStylePattern.body2)
            ),
            Icon(Icons.person_outline,
              size: 12.0,
              color: Palette.primary
            ),
            SizedBox(width: 4.0),
            Text("·",
              style: AppTextStyle.style(AppTextStylePattern.body2)
            ),
            SizedBox(width: 2.0),
            Text("Tap here for more options",
                style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.secondaryLight)
            ),
          ],
        )
      ],
    );
  }

  Widget _appBar(BuildContext context){
    return AppBar(
        // this will change icon color of back icon
        iconTheme: IconThemeData(
          color: Palette.secondaryLight,
        ),
        elevation: 0.0,
        automaticallyImplyLeading: true,
        backgroundColor: Palette.background,
        title: _appBarTitle(),
        centerTitle: true,
        actions: <Widget>[
          Padding(padding:
            EdgeInsets.only(right: 24.0),
            child: ImageIcon(
              AssetImage("assets/icons/filter.png"),
              color: Palette.primary.withOpacity(0.5),
              size: 24.0,
            )
          ),
        ],
    );
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
        appBar: _appBar(context),
        backgroundColor: Palette.background,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: AppDimensions.padding(AppPaddingType.screenWithAppBar).copyWith(left: 0.0, right: 0.0),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: RestaurantCard(),
                  padding: EdgeInsets.symmetric(horizontal: 24.0)
                )
              ),
              SizedBox(height: 16.0),
              Column(
                children: <Widget>[
                  Divider(height: 16.0, thickness: 2.0, color: Palette.secondaryLight.withOpacity(0.7)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: Text("Keep Exploring!", style: AppTextStyle.style(AppTextStylePattern.body3, fontSizeOffset: 1.0, fontWeight: FontWeight.w500)),
                        ),
                        Expanded(
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                      width: 1.0,
                                      color: Palette.secondaryDark
                                  )
                              ),
                              child: Center(child: Text("Deciding...", style: AppTextStyle.style(AppTextStylePattern.body3, fontSizeOffset: 1.0, fontWeight: FontWeight.w500))),
                            )
                        )
                      ],
                    ),
                  )
                ],
              )
            ]
          ),
        ),
      )
    );
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
