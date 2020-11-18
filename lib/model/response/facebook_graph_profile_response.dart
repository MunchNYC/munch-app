import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'facebook_graph_profile_response.jser.dart';

class FacebookGraphProfileResponse{
  String name;
  String email;
  String photoUrl;

  FacebookGraphProfileResponse({this.name, this.email, this.photoUrl});
}

@GenSerializer()
class FacebookGraphProfileResponseJsonSerializer extends Serializer<FacebookGraphProfileResponse> with _$FacebookGraphProfileResponseJsonSerializer {}