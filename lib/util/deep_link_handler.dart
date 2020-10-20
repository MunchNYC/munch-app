import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/repository/munch_repository.dart';
import 'package:munch/widget/screen/swipe/decision_screen.dart';
import 'package:munch/widget/screen/swipe/restaurant_swipe_screen.dart';

import 'app.dart';
import 'navigation_helper.dart';

class DeepLinkHandler{
  static const _methodChannel = const MethodChannel('https.munchapp.io/channel');
  static const _eventChannel = const EventChannel('https.munchapp.io/events');

  DeepLinkRouter _deepLinkRouter = DeepLinkRouter();

  static DeepLinkHandler _instance;

  DeepLinkHandler._internal();

  factory DeepLinkHandler.getInstance() {
    if (_instance == null) {
      _instance = DeepLinkHandler._internal();
    }
    return _instance;
  }

  void initializeDeepLinkListeners(){
    startUri().then(onDeepLinkReceived);

    //Checking broadcast stream, if deep link was clicked in opened appication
    _eventChannel.receiveBroadcastStream().listen((d) => onDeepLinkReceived(d));
  }

  Future<String> startUri() async {
    try {
      return _methodChannel.invokeMethod('initialLink');
    } on PlatformException catch (e) {
      return "Failed to Invoke: '${e.message}'.";
    }
  }

  void onDeepLinkReceived(String deepLink) {
    Uri uri = Uri.parse(deepLink);

    String path = uri.path;
    List<String> pathSegments = uri.pathSegments;

    switch(_deepLinkRouter.getRoute(path)){
      case DeepLinkRoute.MUNCH_ROUTE:
        _deepLinkRouter.executeMunchRoute(pathSegments[1]);
        break;
      default:
        print("No route");
        break;
    }
  }
}

enum DeepLinkRoute{
  MUNCH_ROUTE
}

class DeepLinkRouter{
  static final RegExp munchRoute = RegExp(r'^/munches/[(^/)a-zA-Z0-9]+$');

  final List<RegExp> _routeRegex = [
    munchRoute
  ];

  final Map<RegExp, DeepLinkRoute> _routeMap = Map.of({
    munchRoute: DeepLinkRoute.MUNCH_ROUTE
  });

  DeepLinkRoute getRoute(String path){
    for(int i = 0; i < _routeRegex.length; i++){
      if(_routeRegex[i].hasMatch(path)){
        return _routeMap[_routeRegex[i]];
      }
    }

    return null;
  }

  void executeMunchRoute(String munchId){
    MunchRepo.getInstance().getDetailedMunch(munchId).then((munch){
      Widget screen;

      if(munch.munchStatus == MunchStatus.UNDECIDED) {
        screen = RestaurantSwipeScreen(munch: munch, shouldFetchDetailedMunch: false);
      } else{
        screen = DecisionScreen(munch: munch, shouldFetchDetailedMunch: false);
      }

      NavigationHelper.navigateToWithSpecificNavigator(App.rootNavigatorKey.currentState,
          screen: screen,
          popAllRoutes: true,
          slideTransitionBuilder: NavigationAnimationHelper.rightToLeftAnimation,
      );
    }).catchError((error){
      print(error);
    });
  }
}