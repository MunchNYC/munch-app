// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_sign_in_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleSignInResponse _$GoogleSignInResponseFromJson(Map<String, dynamic> json) {
  return GoogleSignInResponse(
    gender: json['gender'] as String,
    birthday: json['birthday'] as String,
  );
}

Map<String, dynamic> _$GoogleSignInResponseToJson(
        GoogleSignInResponse instance) =>
    <String, dynamic>{
      'gender': instance.gender,
      'birthday': instance.birthday,
    };
