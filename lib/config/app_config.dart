import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'app_config.jser.dart';

class AppConfig {
  String appTitle;
  String apiUrl;
  String apiVersion;
  String googleMapsApiKey;
  String supportEmail;

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
  }

  static AppConfig getInstance(){
    if(_instance == null){
      forEnvironment(null);
    }

    return _instance;
  }

}

@GenSerializer()
class AppConfigJsonSerializer extends Serializer<AppConfig> with _$AppConfigJsonSerializer {}