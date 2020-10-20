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
    setMapValue(ret, 'googleMapsApiKey', model.googleMapsApiKey);
    setMapValue(ret, 'feedbackEmail', model.feedbackEmail);
    setMapValue(ret, 'privacyPolicyUrl', model.privacyPolicyUrl);
    setMapValue(ret, 'termsOfServiceUrl', model.termsOfServiceUrl);
    setMapValue(ret, 'websiteUrl', model.websiteUrl);
    return ret;
  }

  @override
  AppConfig fromMap(Map map) {
    if (map == null) return null;
    final obj = AppConfig();
    obj.appTitle = map['appTitle'] as String;
    obj.apiUrl = map['apiUrl'] as String;
    obj.googleMapsApiKey = map['googleMapsApiKey'] as String;
    obj.feedbackEmail = map['feedbackEmail'] as String;
    obj.privacyPolicyUrl = map['privacyPolicyUrl'] as String;
    obj.termsOfServiceUrl = map['termsOfServiceUrl'] as String;
    obj.websiteUrl = map['websiteUrl'] as String;
    return obj;
  }
}
