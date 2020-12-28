// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facebook_graph_profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FacebookGraphProfileResponse _$FacebookGraphProfileResponseFromJson(
    Map<String, dynamic> json) {
  return FacebookGraphProfileResponse(
    name: json['name'] as String,
    email: json['email'] as String,
    gender: json['gender'] as String,
    birthday: json['birthday'] as String,
    photoUrl: json['photoUrl'] as String,
  );
}

Map<String, dynamic> _$FacebookGraphProfileResponseToJson(
        FacebookGraphProfileResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'gender': instance.gender,
      'birthday': instance.birthday,
      'photoUrl': instance.photoUrl,
    };
