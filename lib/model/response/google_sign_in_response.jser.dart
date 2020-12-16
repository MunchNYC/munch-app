// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_sign_in_response.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$GoogleSignInResponseJsonSerializer implements Serializer<GoogleSignInResponse> {
  @override
  Map<String, dynamic> toMap(GoogleSignInResponse model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'gender', model.gender);
    setMapValue(ret, 'birthday', model.birthday);
    return ret;
  }

  @override
  GoogleSignInResponse fromMap(Map map) {
    if (map == null) return null;
    final obj = GoogleSignInResponse();
    obj.gender = map['gender'] as String;
    obj.birthday = map['birthday'] as String;
    return obj;
  }
}
