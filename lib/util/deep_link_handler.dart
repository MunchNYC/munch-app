import 'package:flutter/services.dart';

class DeepLinkHandler{
  static const _methodChannel = const MethodChannel('munch.munchapp.io/channel');
  static const _eventChannel = const EventChannel('munch.munchapp.io/events');

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

  void onDeepLinkReceived(String uri) {
    print(uri);

    // TODO: Navigation
    /*await MunchRepo.getInstance().getDetailedMunch("4028818c7532787b0175327a36a80000").then((munch){
      NavigationHelper.navigateToWithSpecificNavigator(App.rootNavigatorKey.currentState, screen: HomeScreen(), popAllRoutes: true, transitionDuration: Duration(seconds: 0));

      if(munch.munchStatus == MunchStatus.UNDECIDED) {
        NavigationHelper.navigateToWithSpecificNavigator(
            App.rootNavigatorKey.currentState, screen: RestaurantSwipeScreen(munch: munch, shouldFetchDetailedMunch: false), slideTransitionBuilder: NavigationAnimationHelper.bottomToTopAnimation);
      } else{
        NavigationHelper.navigateToWithSpecificNavigator(
            App.rootNavigatorKey.currentState, screen: DecisionScreen(munch: munch, shouldFetchDetailedMunch: false), slideTransitionBuilder: NavigationAnimationHelper.bottomToTopAnimation);
      }
    });*/
  }
}