import 'dart:async';

import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:munch/analytics/analytics_api.dart';
import 'package:munch/analytics/events/event.dart';
import 'package:munch/api/api.dart';
import 'package:munch/config/constants.dart';
import 'package:munch/model/user.dart';
import 'package:munch/repository/auth_repository.dart';
import 'package:munch/repository/user_repository.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/deep_link_handler.dart';
import 'package:munch/util/navigation_helper.dart';
import 'package:munch/util/notifications_handler.dart';
import 'package:munch/util/utility.dart';
import 'package:munch/widget/screen/splash/include/splash_logo.dart';
import 'package:munch/widget/util/app_status_bar.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  AnimatorKey<double> animatorKey = AnimatorKey<double>();
  Timer _delayedAnimationTimer;
  Timer _reconnectTimer;

  @override
  void dispose() {
    _delayedAnimationTimer?.cancel();
    _reconnectTimer?.cancel();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    App.initAppContext(context);

    _delayedAnimation(milliseconds: 2000);

    _splashScreenNavigationLogic();

    super.didChangeDependencies();
  }

  void _delayedAnimation({int milliseconds}) {
    _delayedAnimationTimer = Timer(Duration(milliseconds: milliseconds), () {
      animatorKey.triggerAnimation();
    });
  }

  void _reconnectAttempt({int seconds}) {
    _delayedAnimationTimer = Timer(Duration(seconds: seconds), () {
      _splashScreenNavigationLogic();
    });
  }

  void _navigateToLoginScreen() {
    NavigationHelper.navigateToLogin(context, fromSplashScreen: true);
  }

  void _splashScreenNavigationLogic() {
    UserRepo.getInstance().getCurrentUser(forceRefresh: true).then((User user) async {
      String deepLink = await DeepLinkHandler.getInstance().getAppStartDeepLink();

      if (user == null) {
        // navigate with delay because if user is not stored in local storage, it will happen very fast, we want to animate splash logo smooth
        Future.delayed(Duration(seconds: 2)).then((value) {
          DeepLinkHandler.getInstance().initializeDeepLinkListener();
          _navigateToLoginScreen();
        });
      } else {
        await NotificationsHandler.getInstance().initializeNotifications();
        DeepLinkHandler.getInstance().initializeDeepLinkListener();

        if (deepLink == null) {
          NavigationHelper.navigateToHome(context, popAllRoutes: true);
        } else {
          DeepLinkHandler.getInstance().onDeepLinkReceived(deepLink);
        }
      }
    }).catchError(_onAuthUserFetchingException);
  }

  void _onAuthUserFetchingException(error, stackTrace) {
    if (error is ServerConnectionException) {
      Utility.showErrorFlushbar(
          error.toString() + "\n" + App.translate("api.error.fetch_data_exception.retry.text"), context);

      // we already waited for CommunicationSettings.maxServerWaitTimeSec so we can execute request again
      _splashScreenNavigationLogic();
    } else if (error is InternetConnectionException) {
      Utility.showErrorFlushbar(
          error.toString() + "\n" + App.translate("api.error.fetch_data_exception.retry.text"), context);

      _reconnectAttempt(seconds: CommunicationSettings.connectionRetryTimeSec);
    } else {
      // TODO: - REMOVE ON 1.0.6
      String stacktracePiece = stackTrace.toString();
      int threshold = stackTrace.toString().length~/4;
      Analytics.getInstance().track(Event('_onAuthUserFetchingException', {'error': error.toString() } ));
      Analytics.getInstance().track(Event('_onAuthUserFetchingException', {'stackTrace1': stacktracePiece.substring(0, threshold) } ));
      Analytics.getInstance().track(Event('_onAuthUserFetchingException', {'stackTrace2': stacktracePiece.substring(threshold, threshold * 2) } ));
      Analytics.getInstance().track(Event('_onAuthUserFetchingException', {'stackTrace3': stacktracePiece.substring(threshold * 2, threshold * 3) } ));
      Analytics.getInstance().track(Event('_onAuthUserFetchingException', {'stackTrace4': stacktracePiece.substring(threshold * 3, threshold * 4) } ));

      AuthRepo.getInstance().signOut();

      _navigateToLoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Palette.background,
        extendBodyBehindAppBar: true,
        appBar: AppStatusBar.getAppStatusBar(iconBrightness: Brightness.light),
        body: Animator(
          animatorKey: animatorKey,
          tween: Tween<double>(begin: 1.0, end: 0.95),
          cycles: 2,
          duration: Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          builder: (context, anim, child) {
            return Transform.scale(scale: anim.value, child: SplashLogo());
          },
          endAnimationListener: (value) {
            _delayedAnimation(milliseconds: 2000);
          },
        ));
  }
}
