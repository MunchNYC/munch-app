// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConfig _$AppConfigFromJson(Map<String, dynamic> json) {
  return AppConfig()
    ..appTitle = json['appTitle'] as String
    ..apiUrl = json['apiUrl'] as String
    ..googleMapsApiKey = json['googleMapsApiKey'] as String
    ..feedbackEmail = json['feedbackEmail'] as String
    ..privacyPolicyUrl = json['privacyPolicyUrl'] as String
    ..termsOfServiceUrl = json['termsOfServiceUrl'] as String
    ..websiteUrl = json['websiteUrl'] as String
    ..deepLinkUrl = json['deepLinkUrl'] as String;
}

Map<String, dynamic> _$AppConfigToJson(AppConfig instance) => <String, dynamic>{
      'appTitle': instance.appTitle,
      'apiUrl': instance.apiUrl,
      'googleMapsApiKey': instance.googleMapsApiKey,
      'feedbackEmail': instance.feedbackEmail,
      'privacyPolicyUrl': instance.privacyPolicyUrl,
      'termsOfServiceUrl': instance.termsOfServiceUrl,
      'websiteUrl': instance.websiteUrl,
      'deepLinkUrl': instance.deepLinkUrl,
    };
