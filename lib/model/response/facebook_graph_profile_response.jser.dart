// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facebook_graph_profile_response.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$FacebookGraphProfileResponseJsonSerializer
    implements Serializer<FacebookGraphProfileResponse> {
  @override
  Map<String, dynamic> toMap(FacebookGraphProfileResponse model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'name', model.name);
    setMapValue(ret, 'email', model.email);
    setMapValue(ret, 'gender', model.gender);
    setMapValue(ret, 'birthday', model.birthday);
    setMapValue(ret, 'photoUrl', model.photoUrl);
    return ret;
  }

  @override
  FacebookGraphProfileResponse fromMap(Map map) {
    if (map == null) return null;
    final obj = FacebookGraphProfileResponse();
    obj.name = map['name'] as String;
    obj.email = map['email'] as String;
    obj.gender = map['gender'] as String;
    obj.birthday = map['birthday'] as String;
    obj.photoUrl = map['photoUrl'] as String;
    return obj;
  }
}
