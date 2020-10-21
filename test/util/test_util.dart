import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:munch/config/localizations.dart';
import 'package:munch/util/app.dart';

class TestUtil{
  static Future testAppWidget({WidgetTester tester, Widget widgetToTest}) async{
    const LocalizationsDelegate<AppLocalizations> delegate = const AppLocalizationsDelegate();
    const Locale testLocale = Locale('en');

    await delegate.load(testLocale);

    await tester.pumpWidget(
      MaterialApp(
          locale: testLocale,
          localizationsDelegates: [delegate],
          home: MediaQuery(
              data: MediaQueryData(),
              child: Builder(
                  builder: (BuildContext context){
                    App.initAppContext(context);

                    return widgetToTest;
                  }
              )
          )
      )
    );

    await tester.idle();
    // The async delegator load will require build on the next frame. Thus, pump
    await tester.pump();
  }

  static void mockPluginMethodChannel(String channelName, var returnValue){
    MethodChannel channel = MethodChannel(channelName);

    channel.setMockMethodCallHandler((MethodCall call) async {
      return returnValue;
    });
  }
}