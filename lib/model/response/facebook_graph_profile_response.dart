import 'package:json_annotation/json_annotation.dart';

part 'facebook_graph_profile_response.g.dart';

@JsonSerializable()
class FacebookGraphProfileResponse {
  String name;
  String email;
  String gender;
  String birthday;
  String photoUrl;

  FacebookGraphProfileResponse({this.name, this.email, this.gender, this.birthday, this.photoUrl});

  factory FacebookGraphProfileResponse.fromJson(Map<String, dynamic> json) => _$FacebookGraphProfileResponseFromJson(json);
}