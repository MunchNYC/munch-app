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

  @override
  void initState() {
    UserRepo.getInstance().getCurrentUser(forceRefresh: true).then((User user) async {
      if(user == null){
        NavigationHelper.navigateToLogin(context, fromSplashScreen: true);
      } else{
        await NotificationsHandler.getInstance().initializeNotifications();

        NavigationHelper.navigateToHome(context, popAllRoutes: true, fromSplashScreen: true);
      }
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    App.initAppContext(context);
    DeepLinkHandler.getInstance().initializeDeepLinkListeners();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:  Palette.background,
        body: SplashLogo()
    );
  }
}