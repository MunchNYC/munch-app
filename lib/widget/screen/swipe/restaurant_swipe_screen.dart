import 'package:animated_widgets/widgets/opacity_animated.dart';
import 'package:animated_widgets/widgets/translation_animated.dart';
import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munch/api/api.dart';
import 'package:munch/config/constants.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/model/restaurant.dart';
import 'package:munch/service/munch/munch_bloc.dart';
import 'package:munch/service/munch/munch_event.dart';
import 'package:munch/service/munch/munch_state.dart';
import 'package:munch/service/notification/notifications_bloc.dart';
import 'package:munch/service/notification/notifications_state.dart';
import 'package:munch/theme/dimensions.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/navigation_helper.dart';
import 'package:munch/util/notifications_handler.dart';
import 'package:munch/util/utility.dart';
import 'package:munch/widget/screen/swipe/tutorial_restaurant_swipe_screen.dart';
import 'package:munch/widget/util/app_bar_back_button.dart';
import 'package:munch/widget/util/app_circular_progress_indicator.dart';
import 'package:munch/widget/util/error_page_widget.dart';
import 'package:munch/widget/util/overlay_dialog_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

import 'include/restaurant_card.dart';

class RestaurantSwipeScreen extends StatefulWidget {
  Munch munch;
  bool tutorialStateInitialized = false;

  // will be true if we need to call back-end to get detailed munch instead of compact
  bool shouldFetchDetailedMunch;

  RestaurantSwipeScreen({this.munch, this.shouldFetchDetailedMunch = false});

  @override
  State<StatefulWidget> createState() {
    return _RestaurantSwipeScreenState();
  }
}

enum TutorialState{
  TUTORIAL_CAROUSEL, TUTORIAL_SWIPE, FINISHED
}

class _RestaurantSwipeScreenState extends State<RestaurantSwipeScreen> {
  static const double SWIPE_TO_SCREEN_RATIO_THRESHOLD = 0.2;
  static const int LAST_SWIPED_RESTAURANTS_BUFFER_CAPACITY = 5;

  AnimatorKey<double> _cardPerspectiveAnimatorKey = AnimatorKey<double>();
  bool _cardPerspectiveAnimationLeft = false;

  Map<String, RestaurantCard> _currentCardMap = Map<String, RestaurantCard>();
  List<Restaurant> _currentRestaurants = List<Restaurant>();

  // Sometimes from back-end are return restaurants which swipes are currently processing so don't need to show them in card stack
  // Because of that we're storing last swiped restaurants in buffer with LAST_SWIPED_RESTAURANTS_BUFFER_CAPACITY
  // Map is created just to optimize speed of detection algorithm
  Map<String, Restaurant> _lastSwipedRestaurantsMap = Map<String, Restaurant>();
  List<Restaurant> _lastSwipedRestaurants = List<Restaurant>();

  MunchBloc _munchBloc;

  bool _animateMatchedRestaurant = false;

  bool _restaurantsApiCallInProgress = false;

  @override
  void initState() {
    _munchBloc = MunchBloc();

    if(widget.shouldFetchDetailedMunch){
      _munchBloc.add(GetDetailedMunchEvent(widget.munch.id));
    } else{
      // merge Munch with itself in order to update members array if it's empty to (1 member - current user)
      // edge case
      widget.munch.merge(widget.munch);

      _throwGetSwipeRestaurantNextPageEvent();
    }

    super.initState();
  }

  @override
  void dispose() {
    _munchBloc?.close();

    super.dispose();
  }

  Widget _tutorialOverlayDialog(Restaurant restaurant, TutorialState tutorialState){
    return Container(
        height: double.infinity,
        width: double.infinity,
        // color must be set otherwise container will be zero-sized, so gesture detectors won't be recognized
        color: Colors.transparent,
        child: TutorialRestaurantSwipeScreen(munch: widget.munch, restaurant: restaurant, tutorialState: tutorialState),
    );
  }

  void _initializeTutorialState(Restaurant restaurant) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    int tutorialStateIndex = sharedPreferences.getInt(StorageKeys.SWIPE_TUTORIAL_STATE);

    TutorialState tutorialState;

    if(tutorialStateIndex == null){
      tutorialState = TutorialState.TUTORIAL_CAROUSEL;
    } else{
      tutorialState = TutorialState.values[tutorialStateIndex];
    }

    if(tutorialState != TutorialState.FINISHED){
      OverlayDialogHelper(isModal: true, widget: _tutorialOverlayDialog(restaurant, tutorialState)).show(context);
    }

    widget.tutorialStateInitialized = true;
  }

  void _throwGetSwipeRestaurantNextPageEvent(){
    if(!_restaurantsApiCallInProgress) {
      _restaurantsApiCallInProgress = true;
      _munchBloc.add(GetRestaurantsPageEvent(widget.munch.id));
    }
  }

  Widget _appBarTitle(){
    // InkWell to make white space around tapable also
    return InkWell(
      onTap: () {
        NavigationHelper.navigateToMunchOptionsScreen(context, munch: widget.munch).then(
           (shouldReloadRestaurants){
             setState(() {
               if(shouldReloadRestaurants) {
                 _currentRestaurants.clear();

                 _throwGetSwipeRestaurantNextPageEvent();
               }
             });
         }); //refresh the data on the page
      },
      child: Column(
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
                Text(widget.munch.getNumberOfMembers().toString(),
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
                Text(App.translate("restaurant_swipe_screen.app_bar.second_line.info_label.text"),
                    style: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.secondaryLight)
                )
              ],
            )
          ],
      )
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
            child: GestureDetector(
              onTap: (){
                NavigationHelper.navigateToFiltersScreen(context, munch: widget.munch).then((filtersSaved) {
                  setState(() {
                    // Don't refresh anything if filters are not saved
                    if(filtersSaved) {
                      _currentRestaurants.clear();

                      _throwGetSwipeRestaurantNextPageEvent();
                    }
                  });
                });
              },
              child: ImageIcon(
                AssetImage("assets/icons/filters.png"),
                color: Palette.primary.withOpacity(0.5),
                size: 24.0,
              ),
            )
          ),
        ],
    );
  }

  Future<bool> _onWillPopScope() async {
    NavigationHelper.popRoute(context, checkLastRoute: true);

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPopScope,
        child: Scaffold(
          appBar: _appBar(context),
          backgroundColor: Palette.background,
          body: Container(
              width: double.infinity,
              height: double.infinity,
              padding: AppDimensions.padding(AppPaddingType.screenWithAppBar).copyWith(top: 8.0, left: 0.0, right: 0.0),
              child: _buildNotificationsBloc()
          )
      )
    );
  }

  void _munchStatusNotificationListener(BuildContext context, NotificationsState state){
    if(state is DetailedMunchNotificationState){
      Munch munch = state.data;

      if(munch.id == widget.munch.id) {
        _checkMunchStatusChanged();
      }
    } else if(state is CurrentUserKickedNotificationState){
      String munchId = state.data;

      if(widget.munch.id == munchId){
        _forceNavigationToHomeScreen();
      }
    }
  }

  Widget _buildNotificationsBloc(){
    return BlocConsumer<NotificationsBloc, NotificationsState>(
        cubit: NotificationsHandler.getInstance().notificationsBloc,
        listenWhen: (NotificationsState previous, NotificationsState current) => (current is DetailedMunchNotificationState || current is CurrentUserKickedNotificationState) && current.ready,
        listener: (BuildContext context, NotificationsState state) => _munchStatusNotificationListener(context, state),
        buildWhen: (NotificationsState previous, NotificationsState current) => current is DetailedMunchNotificationState && current.ready, // in every other condition enter builder
        builder: (BuildContext context, NotificationsState state) => _buildMunchBloc()
    );
  }

  void _navigateToDecisionScreen(){
    NavigationHelper.navigateToDecisionScreen(context, munch: widget.munch, addToBackStack: false);
  }

  void _checkMunchStatusChanged({bool navigateToDecisionScreenIfChanged: false}){
    if(widget.munch.munchStatusChanged){
      widget.munch.munchStatusChanged = false;

      if(widget.munch.munchStatus != MunchStatus.UNDECIDED){
        if(navigateToDecisionScreenIfChanged) {
          _navigateToDecisionScreen();
        } else{
          _animateMatchedRestaurant = true;
        }
      }
    }
  }

  void _updateRestaurantsPage(List<Restaurant> restaurantList) {
    for (int i = 0; i < restaurantList.length; i++) {
      if (_lastSwipedRestaurantsMap.containsKey(restaurantList[i].id) || _currentCardMap.containsKey(restaurantList[i].id)) {
        restaurantList.removeAt(i);
        i--;
      }
    }

    _currentRestaurants.addAll(restaurantList);

    Map<String, RestaurantCard> _newCardMap = Map<String, RestaurantCard>();

    _currentRestaurants.forEach((Restaurant restaurant) {
      // if restaurant is in swipe history buffer, don't include it in new card map
      if (_currentCardMap.containsKey(restaurant.id)) {
        _newCardMap[restaurant.id] = _currentCardMap[restaurant.id];
      } else {
        _newCardMap[restaurant.id] = RestaurantCard(restaurant, munchBloc: _munchBloc);
      }
    });

    _currentCardMap.clear();

    _currentCardMap = _newCardMap;
  }

  void _noMoreCarouselImageListener(MunchState state){
    _cardPerspectiveAnimationLeft = state.data;

    if(_currentRestaurants.length > 0 && !widget.tutorialStateInitialized){
      _initializeTutorialState(_currentRestaurants[0]);
    }

    _cardPerspectiveAnimatorKey.triggerAnimation();

    Vibration.hasVibrator().then((value) async {
      if (value) {
        bool hasAmplitudeControl = await Vibration.hasAmplitudeControl();

        if (hasAmplitudeControl) {
          Vibration.vibrate(duration: 150, amplitude: 10);
        } else {
          Vibration.vibrate(duration: 150);
        }
      }
    });
  }

  void _forceNavigationToHomeScreen(){
    NavigationHelper.navigateToHome(context, popAllRoutes: true);
  }

  void _swipeScreenListener(BuildContext context, MunchState state){
    if (state.hasError) {
      if(state.exception is AccessDeniedException){
        _forceNavigationToHomeScreen();
      }

      Utility.showErrorFlushbar(state.message, context);
    } else if(state is DetailedMunchFetchingState){
      _checkMunchStatusChanged(navigateToDecisionScreenIfChanged: true);

      // when we open this screen and received DetailedMunch data we can fetch restaurants
      _throwGetSwipeRestaurantNextPageEvent();
    } else if(state is RestaurantsPageFetchingState){
      _updateRestaurantsPage(state.data);
    } else if(state is RestaurantSwipeProcessingState){
      _checkMunchStatusChanged();
    } else if(state is NoMoreCarouselImageState){
      _noMoreCarouselImageListener(state);
    }

    if(state is RestaurantsPageFetchingState){
      _restaurantsApiCallInProgress = false;
    }
  }

  Widget _buildMunchBloc(){
    return BlocConsumer<MunchBloc, MunchState>(
        cubit: _munchBloc,
        listenWhen: (MunchState previous, MunchState current) => current.hasError || current.ready,
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
            child: _currentRestaurants.length > 0 ?
            Animator(
              animatorKey: _cardPerspectiveAnimatorKey,
              triggerOnInit: false,
              tween: Tween<double>(
                  begin: 0.0, end: 0.1
              ),
              cycles: 2,
              duration: Duration(milliseconds: 200),
              curve: Curves.linear,
              builder: (context, anim, child){
                  return Transform(
                      // More info about perspective: https://medium.com/flutterdevs/perspective-in-flutter-904c6cade292
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, anim.value * 0.01)
                        ..rotateY(_cardPerspectiveAnimationLeft ? anim.value : -anim.value),
                        alignment: FractionalOffset.center,
                        child: _draggableCard(),
                  );
                })
              : _emptyCardStack(),
            padding: EdgeInsets.symmetric(horizontal: 8.0)
          )
        ),
        SizedBox(height: 8.0),
        Divider(height: 1.0, thickness: 2.0, color: Palette.secondaryLight.withOpacity(0.7)),
        _decisionInfoBar()
      ]
    );
  }

  Widget _emptyCardStack(){
    return Padding(
      padding: EdgeInsets.only(top: 24.0),
      child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(App.translate("restaurant_swipe_screen.empty_card_stack.title"),
                    style: AppTextStyle.style(AppTextStylePattern.heading2, fontWeight: FontWeight.w400, fontSizeOffset: 2.0),
                    textAlign: TextAlign.center),
              ),
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
          Stack(
            children:[
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
          ]),
    );
  }

  Widget _decisionInfoBar(){
    return SafeArea(
      child: Stack(
        children: [
          _buildStillDecidingStatusContainer(),
          if(widget.munch.munchStatus != MunchStatus.UNDECIDED)
          _buildDecidedStatusContainer()
        ],
      )
    );
  }

  Widget _buildStillDecidingStatusContainer(){
    return OpacityAnimatedWidget.tween(
        curve: Curves.easeOut,
        duration: Duration(milliseconds: 200),
        enabled: widget.munch.munchStatus == MunchStatus.UNDECIDED,
        opacityDisabled: 0,
        opacityEnabled: 1,
        child: _stillDecidingStatusContainer()
    );
  }

  Widget _stillDecidingStatusContainer(){
    return Container(
        padding: EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 12.0),
        color: Palette.background,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
                child: Text(App.translate("restaurant_swipe_screen.munch_status.undecided.action_message.text"),
                style: AppTextStyle.style(AppTextStylePattern.body3, fontSizeOffset: 1.0, fontWeight: FontWeight.w500))
            ),
            Expanded(
              child: Material(
                  elevation: 0.0,
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                      decoration: BoxDecoration(
                          color: Palette.background,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              width: 1.0,
                              color: Palette.secondaryDark
                          )
                      ),
                      child: Center(
                          child: Text(App.translate("restaurant_swipe_screen.munch_status.undecided.status.text"),
                              style: AppTextStyle.style(AppTextStylePattern.body3,
                                  color:  Palette.primary,
                                  fontSizeOffset: 1.0,
                                  fontWeight: FontWeight.w500
                              ),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis
                          )
                      )
                  )
              ),
            )
          ]
        )
    );
  }

  Widget _buildDecidedStatusContainer(){
    Widget _decidedStatusContainerWidget = _decidedStatusContainer();

    if(_animateMatchedRestaurant){
      _animateMatchedRestaurant = false;

      return TranslationAnimatedWidget(
          enabled: widget.munch.munchStatus == MunchStatus.DECIDED,
          curve: Curves.bounceInOut,
          duration: Duration(milliseconds: 1500),
          values: [
            Offset(0, 100),// hidden
            Offset(0, -40),
            Offset(0, 0),
          ],
          child: _decidedStatusContainerWidget
      );
    } else{
      return _decidedStatusContainerWidget;
    }
  }

  Widget _decidedStatusContainer(){
    return Container(
        padding: EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 12.0),
        color: Palette.background,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
                child: Text(App.translate("restaurant_swipe_screen.munch_status.decided.action_message.text"),
                    style: AppTextStyle.style(AppTextStylePattern.body3, fontSizeOffset: 1.0, fontWeight: FontWeight.w500))
            ),
            Expanded(
              child: GestureDetector(
                  onTap: _navigateToDecisionScreen,
                  child: Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                        decoration: BoxDecoration(
                            color: Palette.secondaryDark,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                                width: 1.0,
                                color: Palette.secondaryDark
                            )
                        ),
                        child: Center(
                            child: Text(widget.munch.matchedRestaurantName ?? "", // will be null if this field is hidden
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
                    )
                 )
              )
            )
          ]
        )
    );
  }

  void _removeTopCard() {
    _currentCardMap.remove(_currentRestaurants[0].id);

    Restaurant restaurant = _currentRestaurants.removeAt(0);

    if(_lastSwipedRestaurants.length +  1 == LAST_SWIPED_RESTAURANTS_BUFFER_CAPACITY) {
      Restaurant restaurantRemovedFromLastSwipedList = _lastSwipedRestaurants.removeLast();
      _lastSwipedRestaurantsMap.remove(restaurantRemovedFromLastSwipedList.id);
    }

    _lastSwipedRestaurants.insert(0, restaurant);
    _lastSwipedRestaurantsMap[restaurant.id] = restaurant;

    if(_currentRestaurants.length <= 1){
      _throwGetSwipeRestaurantNextPageEvent();
    }
  }

  void _onSwipeLeft(){
    _munchBloc.add(RestaurantSwipeLeftEvent(
        munchId: widget.munch.id,
        restaurantId: _currentRestaurants[0].id)
    );

    setState(() {
      _removeTopCard();
    });
  }

  void _onSwipeRight(){
    _munchBloc.add(RestaurantSwipeRightEvent(
        munchId: widget.munch.id,
        restaurantId: _currentRestaurants[0].id)
    );

    setState(() {
      _removeTopCard();
    });
  }
}
