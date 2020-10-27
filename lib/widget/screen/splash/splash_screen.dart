import 'package:flutter/material.dart';
import 'package:munch/model/user.dart';
import 'package:munch/repository/user_repository.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/deep_link_handler.dart';
import 'package:munch/util/navigation_helper.dart';
import 'package:munch/util/notifications_handler.dart';
import 'package:munch/util/utility.dart';
import 'package:munch/widget/screen/splash/include/splash_logo.dart';
import 'package:munch/widget/util/app_status_bar.dart';


class SplashScreen extends StatefulWidget{
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{
  void _splashScreenNavigationLogic(){
      UserRepo.getInstance().getCurrentUser(forceRefresh: true).then((User user) async {
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
    }).catchError((error){
      Utility.showErrorFlushbar(error.toString(), context);

      NavigationHelper.navigateToLogin(context, fromSplashScreen: true);
    });
  }

  @override
  void didChangeDependencies() {
    App.initAppContext(context);

    _splashScreenNavigationLogic();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Palette.background,
        extendBodyBehindAppBar: true,
        appBar: AppStatusBar.getAppStatusBar(iconBrightness: Brightness.light),
        body: SplashLogo()
    );
  }
}