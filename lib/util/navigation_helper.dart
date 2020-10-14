import 'package:flutter/material.dart';
import 'package:munch/widget/screen/auth/login_screen.dart';
import 'package:munch/widget/screen/home/home_screen.dart';
import 'package:munch/widget/screen/map/map_screen.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/widget/screen/swipe/decision_screen.dart';
import 'package:munch/widget/screen/swipe/filters_screen.dart';
import 'package:munch/widget/screen/swipe/munch_options_screen.dart';
import 'package:munch/widget/screen/swipe/restaurant_swipe_screen.dart';
import 'package:munch/widget/screen/webviews/privacy_policy_screen.dart';
import 'package:munch/widget/screen/webviews/terms_of_service_screen.dart';

class NavigationHelper {
  static PageRouteBuilder _buildPageScreen({Widget screen, Duration transitionDuration: const Duration(milliseconds: 300), Function slideTransitionBuilder}){
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionDuration: transitionDuration,
        transitionsBuilder: slideTransitionBuilder
    );
  }

  static Future _navigateTo(BuildContext context, {bool addToBackStack: false, Widget screen, bool rootNavigator: false,
        Duration transitionDuration: const Duration(milliseconds: 300), Function slideTransitionBuilder, var result}) {
    if (addToBackStack) {
      return Navigator.of(context, rootNavigator: rootNavigator).push(
         _buildPageScreen(screen: screen, transitionDuration: transitionDuration,
             slideTransitionBuilder: slideTransitionBuilder ?? NavigationAnimationHelper.rightToLeftAnimation)
      );
    } else {
      return Navigator.of(context, rootNavigator: rootNavigator).pushReplacement(
         _buildPageScreen(screen: screen, transitionDuration: transitionDuration,
             slideTransitionBuilder: slideTransitionBuilder ?? NavigationAnimationHelper.bottomToTopAnimation), result: result
      );
    }
  }

  static Future navigateToWithSpecificNavigator(NavigatorState navigatorState,
      {bool addToBackStack: true, Widget screen, Duration transitionDuration: const Duration(milliseconds: 300), Function slideTransitionBuilder, var result}) {
    if (addToBackStack) {
      return navigatorState.push(
          _buildPageScreen(screen: screen, transitionDuration: transitionDuration,
              slideTransitionBuilder: slideTransitionBuilder ?? NavigationAnimationHelper.rightToLeftAnimation)
      );
    } else {
      return navigatorState.pushReplacement(
          _buildPageScreen(screen: screen, transitionDuration: transitionDuration,
              slideTransitionBuilder: slideTransitionBuilder ?? NavigationAnimationHelper.bottomToTopAnimation), result: result
      );
    }
  }

  static Future _popAllRoutesAndNavigateTo(BuildContext context,
      {Widget screen, bool rootNavigator: false, Duration transitionDuration: const Duration(milliseconds: 300), Function slideTransitionBuilder}) {
      return Navigator.of(context, rootNavigator: rootNavigator).pushAndRemoveUntil(
          _buildPageScreen(screen: screen, transitionDuration: transitionDuration,
              slideTransitionBuilder: slideTransitionBuilder ?? NavigationAnimationHelper.bottomToTopAnimation),
          (Route<dynamic> route) => false
      );
  }

  static void popRoute(BuildContext context,
      {bool rootNavigator: true, var result}) {
    return Navigator.of(context, rootNavigator: rootNavigator).pop(result);
  }

  static Future navigateToLogin(BuildContext context,
      {bool popAllRoutes: true, bool addToBackStack: false, bool fromSplashScreen: false}) {
    Duration transitionDuration;

    Function slideTransitionBuilder;

    if(!fromSplashScreen){
      transitionDuration = Duration(milliseconds: 300);
    } else{
      // Transition duration which will use Hero Widget for Munch Splash Logo
      transitionDuration = Duration(milliseconds: 2000);
      // noAnimation must be set, otherwise all contents of the page will go from one side to the other side, we want just fade effect
      slideTransitionBuilder = NavigationAnimationHelper.noAnimation;
    }

    if(popAllRoutes){
      return _popAllRoutesAndNavigateTo(context, screen: LoginScreen(fromSplashScreen: fromSplashScreen), rootNavigator: true,
          transitionDuration: transitionDuration, slideTransitionBuilder: slideTransitionBuilder);
    } else {
      // addToBackStack is considered if popAllRoutes = false
      return _navigateTo(context, addToBackStack: addToBackStack, screen: LoginScreen(fromSplashScreen: fromSplashScreen), rootNavigator: true,
        transitionDuration: transitionDuration, slideTransitionBuilder: slideTransitionBuilder);
    }
  }

  static Future navigateToHome(BuildContext context,
      {bool popAllRoutes: false, bool addToBackStack: false, bool fromSplashScreen: false}) {
    Function slideTransitionBuilder;

    if(fromSplashScreen){
      slideTransitionBuilder = NavigationAnimationHelper.noAnimation;
    }

    if(popAllRoutes){
      return _popAllRoutesAndNavigateTo(context, screen: HomeScreen(fromSplashScreen: fromSplashScreen), rootNavigator: true, slideTransitionBuilder: slideTransitionBuilder);
    } else{
      // addToBackStack is considered if popAllRoutes = false
      return _navigateTo(context, addToBackStack: addToBackStack, screen: HomeScreen(fromSplashScreen: fromSplashScreen), rootNavigator: true,
          slideTransitionBuilder: slideTransitionBuilder);
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
      {Munch munch, bool addToBackStack: true, bool shouldFetchDetailedMunch: false, var result}) {
    return _navigateTo(context, addToBackStack: addToBackStack, rootNavigator: true, result: result,
        screen: DecisionScreen(munch: munch, shouldFetchDetailedMunch: shouldFetchDetailedMunch));
  }

  static Future navigateToPrivacyPolicyScreen(BuildContext context,
      {bool addToBackStack: true}) {
    return _navigateTo(context, addToBackStack: addToBackStack, rootNavigator: true,
        screen: PrivacyPolicyScreen());
  }

  static Future navigateToTermsOfServiceScreen(BuildContext context,
      {bool addToBackStack: true}) {
    return _navigateTo(context, addToBackStack: addToBackStack, rootNavigator: true,
        screen: TermsOfServiceScreen());
  }
}

class NavigationAnimationHelper{
  static SlideTransition noAnimation(BuildContext context, Animation animation, Animation secondaryAnimation, Widget child){
    var begin = Offset(0.0, 0.0);
    var end = Offset.zero;
    var curve = Curves.easeInOut;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
        position: animation.drive(tween),
        child: child
    );
  }

  static SlideTransition rightToLeftAnimation(BuildContext context, Animation animation, Animation secondaryAnimation, Widget child){
    var begin = Offset(1.0, 0.0);
    var end = Offset.zero;
    var curve = Curves.easeInOut;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
        position: animation.drive(tween),
        child: child
    );
  }

  static SlideTransition bottomToTopAnimation(BuildContext context, Animation animation, Animation secondaryAnimation, Widget child){
    var begin = Offset(0.0, 1.0);
    var end = Offset.zero;
    var curve = Curves.easeInOut;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
        position: animation.drive(tween),
        child: child
    );
  }


}


