// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$UserJsonSerializer implements Serializer<User> {
  final _genderProcessor = const GenderProcessor();
  Serializer<PushNotificationsInfo> __pushNotificationsInfoJsonSerializer;

  Serializer<PushNotificationsInfo> get _pushNotificationsInfoJsonSerializer =>
      __pushNotificationsInfoJsonSerializer ??= PushNotificationsInfoJsonSerializer();

  @override
  Map<String, dynamic> toMap(User model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValueIfNotNull(ret, 'pushInfo', _pushNotificationsInfoJsonSerializer.toMap(model.pushNotificationsInfo));
    setMapValue(ret, 'userId', model.uid);
    setMapValueIfNotNull(ret, 'email', model.email);
    setMapValueIfNotNull(ret, 'displayName', model.displayName);
    setMapValue(ret, 'birthday', model.birthday);
    setMapValueIfNotNull(ret, 'imageUrl', model.imageUrl);
    return ret;
  }

  @override
  User fromMap(Map map) {
    if (map == null) return null;
    final obj = User();
    obj.pushNotificationsInfo = _pushNotificationsInfoJsonSerializer.fromMap(map['pushInfo'] as Map) ??
        getJserDefault('pushNotificationsInfo') ??
        obj.pushNotificationsInfo;
    obj.uid = map['userId'] as String;
    obj.email = map['email'] as String ?? getJserDefault('email') ?? obj.email;
    obj.displayName = map['displayName'] as String ?? getJserDefault('displayName') ?? obj.displayName;
    obj.gender = _genderProcessor.deserialize(map['gender'] as String);
    obj.birthday = map['birthday'] as String;
    obj.imageUrl = map['imageUrl'] as String ?? getJserDefault('imageUrl') ?? obj.imageUrl;
    return obj;
  }
}

abstract class _$PushNotificationsInfoJsonSerializer implements Serializer<PushNotificationsInfo> {
  @override
  Map<String, dynamic> toMap(PushNotificationsInfo model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'deviceId', model.deviceId);
    setMapValue(ret, 'pushToken', model.fcmToken);
    return ret;
  }

  @override
  PushNotificationsInfo fromMap(Map map) {
    if (map == null) return null;
    final obj = PushNotificationsInfo();
    obj.deviceId = map['deviceId'] as String;
    obj.fcmToken = map['pushToken'] as String;
    return obj;
  }
}
