import 'package:flutter/material.dart';
import 'package:munch/model/user.dart';
import 'package:munch/repository/user_repository.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/navigation_helper.dart';
import 'package:munch/widget/screen/splash/include/splash_logo.dart';


class SplashScreen extends StatefulWidget{
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{

  @override
  void initState() {
    UserRepo.getInstance().fetchCurrentUser().then((User user) {
      if(user == null){
        Future.delayed(Duration(seconds: 1)).then((value) =>
            NavigationHelper.navigateToLogin(context, fromSplashScreen: true)
        );
      } else{
        NavigationHelper.navigateToHome(context, popAllRoutes: true, fromSplashScreen: true);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    App.initAppContext(context);

    return Scaffold(
        backgroundColor:  Palette.background,
        body: SplashLogo()
    );
  }
}