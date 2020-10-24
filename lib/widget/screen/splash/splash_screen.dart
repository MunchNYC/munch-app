import 'package:flutter/material.dart';
import 'package:munch/model/user.dart';
import 'package:munch/repository/user_repository.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/deep_link_handler.dart';
import 'package:munch/util/navigation_helper.dart';
import 'package:munch/util/notifications_handler.dart';
import 'package:munch/widget/screen/splash/include/splash_logo.dart';


class SplashScreen extends StatefulWidget{
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{
  void _splashScreenNavigationLogic(){
      UserRepo.getInstance().getCurrentUser(forceRefresh: true).then((User user) async {
        App.initAppContext(context);

        String deepLink = await DeepLinkHandler.getInstance().getAppStartDeepLink();
        DeepLinkHandler.getInstance().initializeDeepLinkListener();

        if (user == null) {
          NavigationHelper.navigateToLogin(context, fromSplashScreen: true);
        } else {
          await NotificationsHandler.getInstance().initializeNotifications();

          if(deepLink == null) {
            NavigationHelper.navigateToHome(context, popAllRoutes: true, fromSplashScreen: true);
          } else{
            DeepLinkHandler.getInstance().onDeepLinkReceived(deepLink);
          }
        }
    });
  }

  @override
  void initState() {
    _splashScreenNavigationLogic();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:  Palette.background,
        body: SplashLogo()
    );
  }
}