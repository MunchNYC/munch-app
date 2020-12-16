import 'package:munch/model/response/google_sign_in_response.dart';

import 'api.dart';

class GoogleSignInApi extends Api {
  GoogleSignInApi() : super.thirdParty("https://people.googleapis.com/v1/people/me/connections");

  Future<GoogleSignInResponse> getUserProfile(Map<String, String> authHeaders) async {
    String getUrl = "?requestMask.includeField=person.gender";

    var data = await get(getUrl, authHeaders);

    GoogleSignInResponse googleSignInResponse = GoogleSignInResponseJsonSerializer().fromMap(data);

    return googleSignInResponse;
  }
}
