// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    uid: json['userId'] as String,
    email: json['email'] as String,
    displayName: json['displayName'] as String,
    gender: _$enumDecodeNullable(_$GenderEnumMap, json['gender'],
        unknownValue: Gender.NOANSWER),
    birthday: json['birthday'] as String,
    imageUrl: json['imageUrl'] as String,
  )..pushNotificationsInfo = json['pushInfo'] == null
      ? null
      : PushNotificationsInfo.fromJson(
          json['pushInfo'] as Map<String, dynamic>);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'pushInfo': instance.pushNotificationsInfo,
      'userId': instance.uid,
      'email': instance.email,
      'displayName': instance.displayName,
      'gender': _$GenderEnumMap[instance.gender],
      'birthday': instance.birthday,
      'imageUrl': instance.imageUrl,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$GenderEnumMap = {
  Gender.NOANSWER: 'NOANSWER',
  Gender.MALE: 'MALE',
  Gender.FEMALE: 'FEMALE',
  Gender.OTHER: 'OTHER',
};

PushNotificationsInfo _$PushNotificationsInfoFromJson(
    Map<String, dynamic> json) {
  return PushNotificationsInfo(
    deviceId: json['deviceId'] as String,
    fcmToken: json['pushToken'] as String,
  );
}

Map<String, dynamic> _$PushNotificationsInfoToJson(
        PushNotificationsInfo instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'pushToken': instance.fcmToken,
    };
