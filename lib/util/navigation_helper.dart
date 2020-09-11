import 'package:flutter/material.dart';
import 'package:munch/widget/include/map_widget.dart';
import 'package:munch/widget/screen/auth/login_screen.dart';
import 'package:munch/widget/screen/home/home_screen.dart';

class NavigationHelper {
  static Future _navigateTo(BuildContext context,
      {bool addToBackStack: false, Widget screen, bool rootNavigator: false, var result}) {
    if (addToBackStack) {
      return Navigator.of(context, rootNavigator: rootNavigator).push(MaterialPageRoute(builder: (context) => screen));
    } else {
      return Navigator.of(context, rootNavigator: rootNavigator).pushReplacement(MaterialPageRoute(builder: (context) => screen), result: result);
    }
  }

  static Future navigateToWithSpecificNavigator(NavigatorState navigatorState,
      {bool addToBackStack: true, Widget screen, var result}) {
    if (addToBackStack) {
      return navigatorState.push(MaterialPageRoute(builder: (context) => screen));
    } else {
      return navigatorState.pushReplacement(MaterialPageRoute(builder: (context) => screen), result: result);
    }
  }

  static Future _popAllRoutesAndNavigateTo(BuildContext context,
      {Widget screen, bool rootNavigator: false}) {
      return Navigator.of(context, rootNavigator: rootNavigator).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => screen), (Route<dynamic> route) => false
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
      {bool popAllRoutes: true, bool addToBackStack: false}) {
    if(popAllRoutes){
      return _popAllRoutesAndNavigateTo(context, screen: HomeScreen(), rootNavigator: true);
    } else {
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
}


