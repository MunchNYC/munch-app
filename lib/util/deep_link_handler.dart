import 'package:flutter/services.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/repository/munch_repository.dart';
import 'package:munch/repository/user_repository.dart';

import 'app.dart';
import 'navigation_helper.dart';

class DeepLinkHandler{
  static const _methodChannel = const MethodChannel('https.munch-app.com/channel');
  static const _eventChannel = const EventChannel('https.munch-app.com/events');

  DeepLinkRouter _deepLinkRouter = DeepLinkRouter();

  static DeepLinkHandler _instance;

  DeepLinkHandler._internal();

  factory DeepLinkHandler.getInstance() {
    if (_instance == null) {
      _instance = DeepLinkHandler._internal();
    }
    return _instance;
  }

  void initializeDeepLinkListener(){
    //Checking broadcast stream, if deep link was clicked in opened application
    _eventChannel.receiveBroadcastStream().listen((d) => onDeepLinkReceived(d));
  }

  Future<String> getAppStartDeepLink() async {
    try {
      return await _methodChannel.invokeMethod('initialLink');
    } on PlatformException catch (e) {
      return "Failed to Invoke: '${e.message}'.";
    }
  }

  void onDeepLinkReceived(String deepLink) {
    Uri uri = Uri.parse(deepLink);

    String path = uri.path;
    List<String> pathSegments = uri.pathSegments;

    bool userSignedIn = UserRepo.getInstance().currentUser != null;

    switch(_deepLinkRouter.getRoute(path)){
      case DeepLinkRoute.MUNCH_ROUTE:
          if(userSignedIn) {
            _deepLinkRouter.executeMunchRoute(pathSegments[1]);
          }
          break;
      case DeepLinkRoute.JOIN_ROUTE:
          if(userSignedIn) {
            _deepLinkRouter.executeJoinRoute(pathSegments[2]);
          }
          break;
      case DeepLinkRoute.HOME_ROUTE:
          if(userSignedIn) {
            _deepLinkRouter.executeHomeRoute();
          }
          break;
      default:
          print("No route");
          break;
    }
  }
}

enum DeepLinkRoute{
  MUNCH_ROUTE,
  JOIN_ROUTE,
  HOME_ROUTE
}

class DeepLinkRouter{
  static const String MUNCH_ROUTE_PATH = "/munches";
  static const String JOIN_ROUTE_PATH = "/munches/join";
  static const String HOME_ROUTE_PATH = "/munches/home";

  static final RegExp munchRouteRegex = RegExp(r'^' + MUNCH_ROUTE_PATH + r'/[a-zA-Z0-9]+$');
  static final RegExp joinRouteRegex = RegExp(r'^' + JOIN_ROUTE_PATH + r'/[a-zA-Z0-9]{6}$');
  static final RegExp homeRouteRegex = RegExp(r'^' + HOME_ROUTE_PATH + r'$');

  final List<RegExp> _routeRegex = [
    munchRouteRegex,
    joinRouteRegex,
    homeRouteRegex
  ];

  final Map<RegExp, DeepLinkRoute> _routeMap = Map.of({
    munchRouteRegex: DeepLinkRoute.MUNCH_ROUTE,
    joinRouteRegex: DeepLinkRoute.JOIN_ROUTE,
    homeRouteRegex: DeepLinkRoute.HOME_ROUTE
  });

  DeepLinkRoute getRoute(String path){
    for(int i = 0; i < _routeRegex.length; i++){
      if(_routeRegex[i].hasMatch(path)){
        return _routeMap[_routeRegex[i]];
      }
    }

    return null;
  }

  void _navigateOnError(){
      NavigationHelper.navigateToHome(
        null,
        popAllRoutes: true,
        navigatorState: App.rootNavigatorKey.currentState,
      );
  }

  void executeMunchRoute(String munchId){
    MunchRepo.getInstance().getDetailedMunch(munchId).then((munch){
      if(munch.munchStatus == MunchStatus.UNDECIDED) {
        NavigationHelper.navigateToRestaurantSwipeScreen(
          null,
          munch: munch,
          shouldFetchDetailedMunch: false,
          popAllRoutes: true,
          slideTransitionBuilder: NavigationAnimationHelper.rightToLeftAnimation,
          navigatorState: App.rootNavigatorKey.currentState
        );
      } else{
        NavigationHelper.navigateToDecisionScreen(
            null,
            munch: munch,
            shouldFetchDetailedMunch: false,
            popAllRoutes: true,
            slideTransitionBuilder: NavigationAnimationHelper.rightToLeftAnimation,
            navigatorState: App.rootNavigatorKey.currentState
        );
      }
    }).catchError((error){
      _navigateOnError();
    });
  }

  void executeJoinRoute(String munchCode){
    MunchRepo.getInstance().joinMunch(munchCode).then((munch){
      NavigationHelper.navigateToRestaurantSwipeScreen(
          null,
          munch: munch,
          shouldFetchDetailedMunch: false,
          popAllRoutes: true,
          slideTransitionBuilder: NavigationAnimationHelper.rightToLeftAnimation,
          navigatorState: App.rootNavigatorKey.currentState
      );
    }).catchError((error){
      _navigateOnError();
    });
  }

  void executeHomeRoute(){
    NavigationHelper.navigateToHome(
      null,
      popAllRoutes: true,
      navigatorState: App.rootNavigatorKey.currentState,
    );
  }
}