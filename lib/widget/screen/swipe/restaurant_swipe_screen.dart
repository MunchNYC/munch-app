import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/model/restaurant.dart';
import 'package:munch/service/munch/munch_bloc.dart';
import 'package:munch/service/munch/munch_event.dart';
import 'package:munch/service/munch/munch_state.dart';
import 'package:munch/theme/dimensions.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/navigation_helper.dart';
import 'package:munch/util/utility.dart';
import 'package:munch/widget/include/restaurant_card.dart';
import 'package:munch/widget/util/app_circular_progress_indicator.dart';
import 'package:munch/widget/util/error_page_widget.dart';

class RestaurantSwipeScreen extends StatefulWidget {
  Munch munch;

  // will be true if we need to call back-end to get detailed munch instead of compact
  bool shouldFetchDetailedMunch;

  RestaurantSwipeScreen({this.munch, this.shouldFetchDetailedMunch = false});

  @override
  State<StatefulWidget> createState() {
    return _RestaurantSwipeScreenState();
  }
}

class _RestaurantSwipeScreenState extends State<RestaurantSwipeScreen> {
  static const double SWIPE_TO_SCREEN_RATIO_THRESHOLD = 0.2;

  Map<String, RestaurantCard> _currentCardMap = Map<String, RestaurantCard>();
  List<Restaurant> _currentRestaurants = List<Restaurant>();

  MunchBloc _munchBloc;

  @override
  void initState() {
    _munchBloc = MunchBloc();

    if(widget.shouldFetchDetailedMunch){
      _munchBloc.add(GetDetailedMunchEvent(widget.munch.id));
    }

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
            child: _buildMunchBloc()
        )
      )
    );
  }

  void _updateRestaurantsPage(List<Restaurant> restaurantList){
    _currentRestaurants = restaurantList;

    Map<String, RestaurantCard> _newCardMap = Map<String, RestaurantCard>();

    _currentRestaurants.forEach((Restaurant restaurant) {
      if(_currentCardMap.containsKey(restaurant.id)){
        _newCardMap[restaurant.id] = _currentCardMap[restaurant.id];
      } else{
        _newCardMap[restaurant.id] = RestaurantCard(restaurant);
      }
    });

    _currentCardMap.clear();

    _currentCardMap = _newCardMap;
  }

  void _detailedMunchListener(BuildContext context, MunchState state){
    if (state.hasError) {
      Utility.showErrorFlushbar(state.message, context);
    } else if(state is DetailedMunchFetchingState){
      widget.munch = state.data;

      _munchBloc.add(GetSwipeRestaurantsPageEvent(widget.munch.id));
    } else if(state is SwipeRestaurantsPageFetchingState){
      _updateRestaurantsPage(state.data);
    }
  }

  Widget _buildMunchBloc(){
    return BlocConsumer<MunchBloc, MunchState>(
        cubit: _munchBloc,
        listenWhen: (MunchState previous, MunchState current) => current.hasError || current.ready,
        listener: (BuildContext context, MunchState state) => _detailedMunchListener(context, state),
        buildWhen: (MunchState previous, MunchState current) => current is DetailedMunchFetchingState || current is SwipeRestaurantsPageFetchingState,
        builder: (BuildContext context, MunchState state) => _buildSwipeScreen(context, state)
    );
  }

  Widget _buildSwipeScreen(BuildContext context, MunchState state){
    if (state.hasError) {
      return ErrorPageWidget();
    } else if(state.loading || (state.ready && state is DetailedMunchFetchingState)){
      return AppCircularProgressIndicator();
    }

    return _renderScreen(context);
  }

  Widget _renderScreen(BuildContext context){
    return Column(
        children: [
          Expanded(
              child: Container(
                /*
                  must be wrapped inside layout builder,
                  otherwise feedback widget won't work, width and height of it should be defined, because feedback cannot see Expanded widget above
                */
                  child: LayoutBuilder(
                    builder: (context, constraints) => Draggable(
                      child: _currentRestaurants.length > 0 ? _currentCardMap[_currentRestaurants[0].id] : Center(child: Text("No more restaurants")),
                      ignoringFeedbackSemantics: false,
                      feedback: Container (
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        child: _currentRestaurants.length > 0 ? _currentCardMap[_currentRestaurants[0].id] : Center(child: Text("No more restaurants")),
                      ),
                      childWhenDragging: _currentRestaurants.length > 1 ? _currentCardMap[_currentRestaurants[1].id] : Center(child: Text("No more restaurants")),
                      onDragEnd: (DraggableDetails details){
                        double swipeToScreenRatio = (details.offset.dx.abs() / App.screenWidth);

                        if(swipeToScreenRatio > SWIPE_TO_SCREEN_RATIO_THRESHOLD){
                          if(details.offset.dx < 0){
                            _onSwipeLeft();
                          } else{
                            _onSwipeRight();
                          }
                        }
                      },
                    ),
                  ),
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
    );
  }

  void _removeCard() {
    setState(() {
      _currentCardMap.remove(_currentRestaurants[0].id);
      _currentRestaurants.removeAt(0);

      if(_currentRestaurants.length == 1){
        _munchBloc.add(GetSwipeRestaurantsPageEvent(widget.munch.id));
      }
    });
  }

  void _onSwipeLeft(){
    _removeCard();
  }

  void _onSwipeRight(){
    _removeCard();
  }
}
