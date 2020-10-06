import 'package:flutter/material.dart';
import 'package:munch/widget/screen/auth/login_screen.dart';
import 'package:munch/widget/screen/home/home_screen.dart';
import 'package:munch/widget/screen/map/map_screen.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/widget/screen/swipe/decision_screen.dart';
import 'package:munch/widget/screen/swipe/filters_screen.dart';
import 'package:munch/widget/screen/swipe/munch_options_screen.dart';
import 'package:munch/widget/screen/swipe/restaurant_swipe_screen.dart';

class NavigationHelper {
  static Future _navigateTo(BuildContext context,
      {bool addToBackStack: false, Widget screen, bool rootNavigator: false, var result}) {
    if (addToBackStack) {
      return Navigator.of(context, rootNavigator: rootNavigator).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => screen,
          transitionsBuilder: NavigationAnimationHelper._rightToLeftAnimation
        )
      );
    } else {
      return Navigator.of(context, rootNavigator: rootNavigator).pushReplacement(
          PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => screen,
              transitionsBuilder: NavigationAnimationHelper._bottomToTopAnimation
          )
      );
    }
  }

  static Future navigateToWithSpecificNavigator(NavigatorState navigatorState,
      {bool addToBackStack: true, Widget screen, var result}) {
    if (addToBackStack) {
      return navigatorState.push(
          PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => screen,
              transitionsBuilder: NavigationAnimationHelper._rightToLeftAnimation
          )
      );
    } else {
      return navigatorState.pushReplacement(
          PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => screen,
              transitionsBuilder: NavigationAnimationHelper._bottomToTopAnimation
          )
      );
    }
  }

  static Future _popAllRoutesAndNavigateTo(BuildContext context,
      {Widget screen, bool rootNavigator: false, var result}) {
      return Navigator.of(context, rootNavigator: rootNavigator).pushAndRemoveUntil(
          PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => screen,
              transitionsBuilder: NavigationAnimationHelper._bottomToTopAnimation
          ),
          (Route<dynamic> route) => false
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
      {Munch munch, bool shouldFetchDetailedMunch: false, bool addToBackStack: true, var result}) {
    return _navigateTo(context, addToBackStack: addToBackStack, rootNavigator: true, result: result,
        screen: RestaurantSwipeScreen(munch: munch, shouldFetchDetailedMunch: shouldFetchDetailedMunch));
  }

  static Future navigateToMunchOptionsScreen(BuildContext context,
      {Munch munch, bool addToBackStack: true}) {
    return _navigateTo(context, addToBackStack: addToBackStack, rootNavigator: true,
        screen: MunchOptionsScreen(munch: munch));
  }

  static Future navigateToFiltersScreen(BuildContext context,
      {Munch munch, bool addToBackStack: true}) {
    return _navigateTo(context, addToBackStack: addToBackStack, rootNavigator: true,
        screen: FiltersScreen(munch: munch));
  }

  static Future navigateToDecisionScreen(BuildContext context,
      {Munch munch, bool addToBackStack: true, bool shouldFetchDetailedMunch: false}) {
    return _navigateTo(context, addToBackStack: addToBackStack, rootNavigator: true,
        screen: DecisionScreen(munch: munch, shouldFetchDetailedMunch: shouldFetchDetailedMunch));
  }
}

class NavigationAnimationHelper{
  static SlideTransition _rightToLeftAnimation(BuildContext context, Animation animation, Animation secondaryAnimation, Widget child){
    var begin = Offset(1.0, 0.0);
    var end = Offset.zero;
    var curve = Curves.ease;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
        position: animation.drive(tween),
        child: child
    );
  }

  static SlideTransition _bottomToTopAnimation(BuildContext context, Animation animation, Animation secondaryAnimation, Widget child){
    var begin = Offset(0.0, 1.0);
    var end = Offset.zero;
    var curve = Curves.ease;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
        position: animation.drive(tween),
        child: child
    );
  }

}


