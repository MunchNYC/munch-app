import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:munch/model/response/facebook_graph_profile_response.dart';
import 'package:munch/util/app.dart';

import 'api.dart';

class FacebookGraphApi extends Api {
  static const String API_VERSION = "2.12";

  FacebookGraphApi() : super.thirdParty("https://graph.facebook.com/v" + API_VERSION);

  Future<FacebookGraphProfileResponse> getUserProfile(String accessToken) async {
    String getUrl = "/me?fields=name,first_name,last_name,email,picture,gender,birthday&access_token=$accessToken";

    var data = await get(getUrl);

    data["photoUrl"] = data["picture"]["data"]["url"];

    FacebookGraphProfileResponse facebookGraphProfileResponse =
        FacebookGraphProfileResponseJsonSerializer().fromMap(data);

    return facebookGraphProfileResponse;
  }

  @override
  dynamic returnResponse(http.Response response) {
    print(response.statusCode);
    print(response.body);

    // if that's response with no content
    if (response.statusCode == 204) {
      return null;
    }

    var responseJson = json.decode(response.body.toString());

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return responseJson;
    }

    switch (response.statusCode) {
      case 400:
        throw BadRequestException(response.statusCode, responseJson['status']);
      case 401:
        throw UnauthorisedException(response.statusCode, {"message": App.translate("api.error.unauthorized")});
      case 403:
        throw AccessDeniedException(response.statusCode, responseJson['status']);
      case 404:
        throw NotFoundException(response.statusCode, responseJson['status']);
      case 422:
        throw ValidationException(response.statusCode, responseJson['status']);
      case 500:
        throw InternalServerErrorException(response.statusCode, responseJson['status']);
      default:
        throw FetchDataException.fromMessage(json.decode(response.body.toString()));
    }
  }
}
