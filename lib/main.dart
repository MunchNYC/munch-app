import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/widget/screen/splash/splash_screen.dart';
import 'package:munch/widget/util/stateful_wrapper.dart';
import 'package:smartlook/smartlook.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'config/app_config.dart';
import 'config/firebase_listener.dart';
import 'config/localizations.dart';

Future loadEnvironment() async {
  const ENV = String.fromEnvironment('ENV', defaultValue: 'dev');
  await AppConfig.forEnvironment(ENV);

  await App.initializeDeviceData();

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

  void _configureFirebase() {
    _firebaseListener = FirebaseListener();
    _firebaseListener.listen();
  }

  void _setSystemSettings() {
    // Just default values, which are overridden when AppBar widget is present
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent, // navigation bar color
        statusBarColor: Colors.transparent, // status bar color
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark)); // status bar colorSystemUiOverlayStyle.light);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void initializeApp() {
    _setSystemSettings();
    _configureFirebase();

    tz.initializeTimeZones();
  }

  @override
  Widget build(BuildContext context) {
    SetupOptions options = (new SetupOptionsBuilder('4af32dcf3dbf2c8314683ec324339899c7ec9a52')).build();
    Smartlook.setupAndStartRecording(options);
    return StatefulWrapper(
        onInit: initializeApp,
        child: MaterialApp(
          navigatorKey: App.rootNavigatorKey,
          title: AppConfig.getInstance().appTitle,
          theme: ThemeData(
              primarySwatch: Palette.generateMaterialColor(Palette.primary),
              backgroundColor: Palette.background,
              fontFamily: AppTextStyle.APP_FONT,
              textSelectionHandleColor: Palette.secondaryDark.withOpacity(0.7),
              textSelectionColor: Palette.secondaryDark.withOpacity(0.7),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              appBarTheme: AppBarTheme(
                brightness: Brightness.light,
                // this means by default status bar icons will be dark above app bar, inverse logic
                color: Palette.background,
                shadowColor: Colors.transparent,
              )),
          locale: Locale("en"),
          // switch between en and ru to see effect
          localizationsDelegates: [const AppLocalizationsDelegate()],
          supportedLocales: [const Locale('en')],
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
          onGenerateRoute: null,
        ));
  }
}
