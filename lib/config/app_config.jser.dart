// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$AppConfigJsonSerializer implements Serializer<AppConfig> {
  @override
  Map<String, dynamic> toMap(AppConfig model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'appTitle', model.appTitle);
    setMapValue(ret, 'apiUrl', model.apiUrl);
    setMapValue(ret, 'apiVersion', model.apiVersion);
    setMapValue(ret, 'googleMapsApiKey', model.googleMapsApiKey);
    setMapValue(ret, 'supportEmail', model.supportEmail);
    return ret;
  }

  @override
  AppConfig fromMap(Map map) {
    if (map == null) return null;
    final obj = AppConfig();
    obj.appTitle = map['appTitle'] as String;
    obj.apiUrl = map['apiUrl'] as String;
    obj.apiVersion = map['apiVersion'] as String;
    obj.googleMapsApiKey = map['googleMapsApiKey'] as String;
    obj.supportEmail = map['supportEmail'] as String;
    return obj;
  }
}
