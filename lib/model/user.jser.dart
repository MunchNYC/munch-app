// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$UserJsonSerializer implements Serializer<User> {
  @override
  Map<String, dynamic> toMap(User model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'userId', model.uid);
    setMapValueIfNotNull(ret, 'email', model.email);
    setMapValue(ret, 'displayName', model.displayName);
    return ret;
  }

  @override
  User fromMap(Map map) {
    if (map == null) return null;
    final obj = User();
    obj.uid = map['userId'] as String;
    obj.email = map['email'] as String ?? getJserDefault('email') ?? obj.email;
    obj.displayName = map['displayName'] as String;
    return obj;
  }
}
