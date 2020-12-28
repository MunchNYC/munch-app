import 'package:json_annotation/json_annotation.dart';

part 'google_sign_in_response.g.dart';

@JsonSerializable()
class GoogleSignInResponse {
  String gender;
  String birthday;

  GoogleSignInResponse({this.gender, this.birthday});

  factory GoogleSignInResponse.fromJson(Map<String, dynamic> json) => _$GoogleSignInResponseFromJson(json);
}