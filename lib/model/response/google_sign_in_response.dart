import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'google_sign_in_response.jser.dart';

class GoogleSignInResponse {
  String gender;
  String birthday;

  GoogleSignInResponse({this.gender, this.birthday});
}

@GenSerializer()
class GoogleSignInResponseJsonSerializer
    extends Serializer<GoogleSignInResponse>
    with _$GoogleSignInResponseJsonSerializer {}
