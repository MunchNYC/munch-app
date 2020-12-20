import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:package_info/package_info.dart';

part 'app_config.jser.dart';

class AppConfig {
  String appTitle;
  String apiUrl;
  String googleMapsApiKey;
  String feedbackEmail;
  String privacyPolicyUrl;
  String termsOfServiceUrl;
  String websiteUrl;
  String deepLinkUrl;
  @Field.ignore()
  PackageInfo packageInfo;

  static AppConfig _instance;

  static Future forEnvironment(String env) async {
    // set default to dev if nothing was passed
    env = env ?? 'dev';

    // load the json file
    final contents = await rootBundle.loadString(
      'assets/config/$env.json',
    );

    // decode our json
    final json = jsonDecode(contents);

    // convert our JSON into an instance of our AppConfig class
    _instance = AppConfigJsonSerializer().fromMap(json);
    _instance.packageInfo = await PackageInfo.fromPlatform();
  }

  static AppConfig getInstance() {
    if (_instance == null) {
      forEnvironment(null);
    }

    return _instance;
  }
}

@GenSerializer()
class AppConfigJsonSerializer extends Serializer<AppConfig> with _$AppConfigJsonSerializer {}
