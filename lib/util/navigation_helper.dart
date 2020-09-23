import 'package:flutter/material.dart';
import 'package:munch/widget/screen/auth/login_screen.dart';
import 'package:munch/widget/screen/home/home_screen.dart';
import 'package:munch/widget/screen/map/map_screen.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/widget/screen/swipe/munch_options_screen.dart';
import 'package:munch/widget/screen/swipe/restaurant_swipe_screen.dart';
import 'package:page_transition/page_transition.dart';

class NavigationHelper {
  static Future _navigateTo(BuildContext context,
      {bool addToBackStack: false, Widget screen, bool rootNavigator: false, var result}) {
    if (addToBackStack) {
      return Navigator.of(context, rootNavigator: rootNavigator).push(PageTransition(type: PageTransitionType.rightToLeft, child: screen));
    } else {
      return Navigator.of(context, rootNavigator: rootNavigator).pushReplacement(PageTransition(type: PageTransitionType.downToUp, child: screen));
    }
  }

  static Future openFullScreenDialog(BuildContext context,
      {bool addToBackStack: true, Widget fullScreenDialog, rootNavigator: true}) {
      return Navigator.of(context, rootNavigator: rootNavigator).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __){
            return fullScreenDialog;
          }
      ));
  }

  static Future navigateToWithSpecificNavigator(NavigatorState navigatorState,
      {bool addToBackStack: true, Widget screen, var result}) {
    if (addToBackStack) {
      return navigatorState.push(PageTransition(type: PageTransitionType.rightToLeft, child: screen));
    } else {
      return navigatorState.pushReplacement(PageTransition(type: PageTransitionType.downToUp, child: screen));
    }
  }

  static Future _popAllRoutesAndNavigateTo(BuildContext context,
      {Widget screen, bool rootNavigator: false, var result}) {
      return Navigator.of(context, rootNavigator: rootNavigator).pushAndRemoveUntil(
          PageTransition(type: PageTransitionType.downToUp, child: screen), (Route<dynamic> route) => false
      );
  }

  static void popRoute(BuildContext context,
      {bool rootNavigator: false, var result}) {
    return Navigator.of(context, rootNavigator: rootNavigator).pop(result);
  }

  static Future navigateToLogin(BuildContext context,
      {bool popAllRoutes: true, bool addToBackStack: false}) {
    if(popAllRoutes){
      return _popAllRoutesAndNavigateTo(context, screen: LoginScreen(), rootNavigator: true);
    } else {
      // addToBackStack is considered if popAllRoutes = false
      return _navigateTo(context, addToBackStack: addToBackStack,
          screen: LoginScreen(),
          rootNavigator: true);
    }
  }

  static Future navigateToHome(BuildContext context,
      {bool popAllRoutes: false, bool addToBackStack: false}) {
    if(popAllRoutes){
      return _popAllRoutesAndNavigateTo(context, screen: HomeScreen(), rootNavigator: true);
    } else{
      // addToBackStack is considered if popAllRoutes = false
      return _navigateTo(context, addToBackStack: addToBackStack,
          screen: HomeScreen(),
          rootNavigator: true);
    }
  }

  static Future navigateToMapScreen(BuildContext context,
      {String munchName, bool addToBackStack: true}) {
    return _navigateTo(context, addToBackStack: addToBackStack,
        screen: MapScreen(munchName: munchName));
  }

  static Future navigateToRestaurantSwipeScreen(BuildContext context,
      {Munch munch, bool shouldFetchDetailedMunch: false, bool addToBackStack: true}) {
    return _navigateTo(context, addToBackStack: addToBackStack, rootNavigator: true,
        screen: RestaurantSwipeScreen(munch: munch, shouldFetchDetailedMunch: shouldFetchDetailedMunch));
  }

  static Future navigateToMunchOptionsScreen(BuildContext context,
      {Munch munch, bool addToBackStack: true}) {
    return _navigateTo(context, addToBackStack: addToBackStack, rootNavigator: true,
        screen: MunchOptionsScreen(munch: munch));
  }
}


