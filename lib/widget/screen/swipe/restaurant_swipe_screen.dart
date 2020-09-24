import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:munch/widget/util/app_bar_back_button.dart';
import 'package:munch/widget/util/app_circular_progress_indicator.dart';
import 'package:munch/widget/util/custom_button.dart';
import 'package:munch/widget/util/error_page_widget.dart';

import 'include/restaurant_card.dart';

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
    } else{
      // merge Munch with itself in order to update members array if it's empty to (1 member - current user)
      _updateMunchWithDetailedData(widget.munch);

      _throwGetSwipeRestaurantNextPageEvent();
    }

    super.initState();
  }

  @override
  void dispose() {
    _munchBloc?.close();

    super.dispose();
  }

  void _throwGetSwipeRestaurantNextPageEvent(){
    _munchBloc.add(GetRestaurantsPageEvent(widget.munch.id));
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
            GestureDetector(
              onTap: (){
                NavigationHelper.navigateToMunchOptionsScreen(context, munch: widget.munch).then((munch){
                  if(munch != null){
                    setState(() {
                      widget.munch = munch;
                    });
                  }
                });
              },
              child: Text(App.translate("restaurant_swipe_screen.app_bar.second_line.info_label.text"),
                  style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.secondaryLight)
              ),
            )

          ],
        )
      ],
    );
  }

  /*
    Listener (solo or inside BlocConsumer) is always called before builder method for same state, wherever it's defined
    _swipeScreenListener is always called first even if it's deeper in widget tree
  */
  Widget _appBarTitleBuilder(){
    return BlocBuilder<MunchBloc, MunchState>(
      cubit: _munchBloc,
      buildWhen: (MunchState previous, MunchState current) => (current is DetailedMunchFetchingState) && current.ready,
      builder: (BuildContext context, MunchState state) => _appBarTitle(),
    );
  }

  Widget _appBar(BuildContext context){
    return AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: AppBarBackButton(),
        backgroundColor: Palette.background,
        title: _appBarTitleBuilder(),
        centerTitle: true,
        actions: <Widget>[
          Padding(padding:
            EdgeInsets.only(right: 24.0),
            child: ImageIcon(
              AssetImage("assets/icons/filters.png"),
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

  void _updateMunchWithDetailedData(Munch detailedMunch){
    /*
      Take old data from munch which can be missing from detailedMunch response
      (part of data can be from compactMunch and part of data can be missing because of 206 partial content)
    */
    detailedMunch.merge(widget.munch);

    widget.munch = detailedMunch;
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

  void _swipeScreenListener(BuildContext context, MunchState state){
    if (state.hasError) {
      Utility.showErrorFlushbar(state.message, context);
    } else if(state is DetailedMunchFetchingState){
      _updateMunchWithDetailedData(state.data);

      // when we open this screen and received DetailedMunch data we can fetch restaurants
      _throwGetSwipeRestaurantNextPageEvent();
    } else if(state is RestaurantsPageFetchingState){
      _updateRestaurantsPage(state.data);
    } else if(state is RestaurantSwipeProcessingState){
      if(state.loading){
        _removeTopCard();
      } else {
        // ready state
        _updateMunchWithDetailedData(state.data);
      }
    }
  }

  Widget _buildMunchBloc(){
    return BlocConsumer<MunchBloc, MunchState>(
        cubit: _munchBloc,
        listenWhen: (MunchState previous, MunchState current) => current.hasError || current.ready || (current.loading && current is RestaurantSwipeProcessingState),
        listener: (BuildContext context, MunchState state) => _swipeScreenListener(context, state),
        buildWhen: (MunchState previous, MunchState current) => ! (current is RestaurantSwipeProcessingState && current.hasError) , // in every other condition enter builder
        builder: (BuildContext context, MunchState state) => _buildSwipeScreen(context, state)
    );
  }

  Widget _buildSwipeScreen(BuildContext context, MunchState state){
    if (state.hasError) {
      return ErrorPageWidget();
    }

    bool showLoadingIndicator = false;

    if((state.initial || state.loading || state is DetailedMunchFetchingState)){
      // even if DetailedMunchFetchingState is ready we have to wait for restaurants page to be ready
      // if RestaurantSwipeProcessingState is loading, don't render this indicator
      showLoadingIndicator = true;

      if((state is RestaurantsPageFetchingState || state is RestaurantSwipeProcessingState) && _currentRestaurants.length != 0){
        // if RestaurantsPageFetchingState or RestaurantSwipeProcessingState and one (or more) card is on top of the stack, don't render indicator
        showLoadingIndicator = false;
      }
    }

    if(showLoadingIndicator){
      return AppCircularProgressIndicator();
    } else{
      // if RestaurantSwipeProcessingState is loading, just render screen because card should be immediately removed
      return _renderScreen(context);
    }
  }

  Widget _renderScreen(BuildContext context){
    return Column(
      children: [
        Expanded(
          child: Container(
            child: _currentRestaurants.length > 0 ? _draggableCard() : _emptyCardStack(),
            padding: EdgeInsets.symmetric(horizontal: 24.0)
          )
        ),
        SizedBox(height: 16.0),
        Divider(height: 16.0, thickness: 2.0, color: Palette.secondaryLight.withOpacity(0.7)),
        Padding(
          padding: EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 16.0),
          child: _decisionInfoBar()
        )
      ]
    );
  }

  Widget _emptyCardStack(){
    return Padding(
      padding: EdgeInsets.only(top: 24.0),
      child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(App.translate("restaurant_swipe_screen.empty_card_stack.title"),
                  style: AppTextStyle.style(AppTextStylePattern.heading2, fontWeight: FontWeight.w400, fontSizeOffset: 2.0),
                  textAlign: TextAlign.center),
              SizedBox(height: 36.0),
              widget.munch.munchStatus == MunchStatus.UNDECIDED ?
                Text(App.translate("restaurant_swipe_screen.empty_card_stack.undecided.description"),
                    style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w500, color: Palette.primary.withOpacity(0.7)), textAlign: TextAlign.center)
              : Text(App.translate("restaurant_swipe_screen.empty_card_stack.decided.description.first_sentence") + " " + widget.munch.matchedRestaurant.name + ". " + App.translate("restaurant_swipe_screen.empty_card_stack.decided.description.second_sentence"),
                    style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w500, color: Palette.primary.withOpacity(0.7)), textAlign: TextAlign.center),
        ]
      ),
    );
  }

  /*
    must be wrapped inside layout builder,
    otherwise feedback widget won't work, width and height of it should be defined, because feedback cannot see Expanded widget above
  */
  Widget _draggableCard(){
    return LayoutBuilder(
      builder: (context, constraints) =>
          Draggable(
            child: _currentCardMap[_currentRestaurants[0].id],
            ignoringFeedbackSemantics: false,
            feedback: Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: _currentCardMap[_currentRestaurants[0].id],
            ),
            childWhenDragging: _currentRestaurants.length > 1
                ? _currentCardMap[_currentRestaurants[1].id]
                : Container(),
            onDragEnd: (DraggableDetails details) {
              double swipeToScreenRatio = (details.offset.dx.abs() /
                  App.screenWidth);

              if (swipeToScreenRatio > SWIPE_TO_SCREEN_RATIO_THRESHOLD) {
                if (details.offset.dx < 0) {
                  _onSwipeLeft();
                } else {
                  _onSwipeRight();
                }
              }
            },
          ),
    );
  }

  Widget _decisionInfoBar(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Text(widget.munch.munchStatus == MunchStatus.UNDECIDED ?
                    App.translate("restaurant_swipe_screen.munch_status.undecided.action_message.text") :
                    App.translate("restaurant_swipe_screen.munch_status.decided.action_message.text"),
              style: AppTextStyle.style(AppTextStylePattern.body3, fontSizeOffset: 1.0, fontWeight: FontWeight.w500)
          ),
        ),
        Expanded(
          child: Material(
            elevation: widget.munch.munchStatus == MunchStatus.UNDECIDED ? 0.0 : 4.0,
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              decoration: BoxDecoration(
                  color: widget.munch.munchStatus == MunchStatus.UNDECIDED ? Palette.background : Palette.secondaryDark,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                      width: 1.0,
                      color: Palette.secondaryDark
                  )
              ),
              child: Center(
                  child: widget.munch.munchStatus == MunchStatus.UNDECIDED ?
                    Text(App.translate("restaurant_swipe_screen.munch_status.undecided.status.text"),
                      style: AppTextStyle.style(AppTextStylePattern.body3,
                      color:  Palette.primary,
                      fontSizeOffset: 1.0,
                      fontWeight: FontWeight.w500
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis
                    )
                  : GestureDetector(
                    onTap: (){
                      NavigationHelper.navigateToDecisionScreen(context, munch: widget.munch, addToBackStack: false);
                    },
                    child: Text(widget.munch.matchedRestaurant.name,
                      style: AppTextStyle.style(AppTextStylePattern.body3,
                          color: Palette.background,
                          fontSizeOffset: 1.0,
                          fontWeight: FontWeight.w500
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip
                    )
                  )
              ),
            )
          )
        )
      ],
    );
  }

  void _removeTopCard() {
    _currentCardMap.remove(_currentRestaurants[0].id);
    _currentRestaurants.removeAt(0);

    if(_currentRestaurants.length <= 1){
      _throwGetSwipeRestaurantNextPageEvent();
    }
  }

  void _onSwipeLeft(){
    _munchBloc.add(RestaurantSwipeLeftEvent(
        munchId: widget.munch.id,
        restaurantId: _currentRestaurants[0].id)
    );
  }

  void _onSwipeRight(){
    _munchBloc.add(RestaurantSwipeRightEvent(
        munchId: widget.munch.id,
        restaurantId: _currentRestaurants[0].id)
    );
  }
}
