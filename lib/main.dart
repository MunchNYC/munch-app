import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:munch/repository/user_repository.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/widget/screen/auth/login_screen.dart';
import 'package:munch/widget/screen/home/home_screen.dart';
import 'package:munch/widget/util/app_circular_progress_indicator.dart';
import 'package:munch/widget/util/stateful_wrapper.dart';
import 'config/app_config.dart';
import 'config/firebase_listener.dart';
import 'config/localizations.dart';
import 'model/user.dart';
import 'package:timezone/data/latest.dart' as tz;

Future loadEnvironment() async{
  const ENV = String.fromEnvironment('ENV', defaultValue: 'dev');
  await AppConfig.forEnvironment(ENV);

  await Firebase.initializeApp();
}

void main() {
  // Needs to be called if runApp is called after future is finished, like below
  WidgetsFlutterBinding.ensureInitialized();

  loadEnvironment().then((value) {
    runApp(MunchApp());
  });
}

class MunchApp extends StatelessWidget {
  FirebaseListener _firebaseListener;

  void _configureFirebase(){
    _firebaseListener = FirebaseListener();
    _firebaseListener.listen();
  }

  void _setSystemSettings(){
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void initializeApp(){
    _setSystemSettings();
    _configureFirebase();

    tz.initializeTimeZones();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
        onInit: initializeApp,
        child: MaterialApp(
            title: AppConfig.getInstance().appTitle,
            theme: ThemeData(
              primarySwatch: Palette.generateMaterialColor(Palette.primary),
              backgroundColor: Palette.background,
              fontFamily: AppTextStyle.APP_FONT,
              textSelectionHandleColor: Palette.secondaryDark.withOpacity(0.7),
              textSelectionColor: Palette.secondaryDark.withOpacity(0.7),
            ),
            locale: Locale("en"), // switch between en and ru to see effect
            localizationsDelegates: [const AppLocalizationsDelegate()],
            supportedLocales: [const Locale('en')],
            debugShowCheckedModeBanner: false,
            home: _buildHomeWidget(),
            onGenerateRoute: null,
        )
    );
  }

  Widget _buildHomeWidget(){
    return FutureBuilder(
      future: UserRepo.getInstance().fetchCurrentUser(),
      builder: (context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppCircularProgressIndicator();
        }

        App.initAppContext(context);

        if (snapshot.hasData) {
          return HomeScreen();
        }

        return LoginScreen();
      }
    );
  }

}
