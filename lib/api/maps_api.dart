import 'package:uuid/uuid.dart';
import 'package:munch/model/coordinates.dart';
import 'package:munch/model/response/autocomplete_responses.dart';

import 'api.dart';

class MapsApi extends Api {
  static const String ENDPOINT_SET_PREFIX = 'map/search';
  static const int API_VERSION = 1;

  MapsApi() : super(endpointSetPrefix: ENDPOINT_SET_PREFIX, version: API_VERSION);

  Future<AutocompleteResponses> getAutocomplete(String sessionToken, String input, Coordinates coordinates) async {
    String postUrl = "/autocomplete";

    Map<String, dynamic> body = {
      "sessionToken": sessionToken,
      "coordinates": {
        "longitude": 12.1234,
        "latitude": 12.1
      },
      "input": input
    };

    var data = await post(postUrl, body);

    AutocompleteResponses getAutocompleteResponses = AutocompleteResponsesJsonSerializer().fromMap(data);
  }

  Future<Coordinates> getCoordinates(String sessionToken, String placeId) async {
    String postUrl = "/coordinates";

    Map<String, dynamic> body = {
      "sessionToken": sessionToken,
      "placeId": placeId
    };
    var data = await post(postUrl, body);

    Coordinates coordinates = CoordinatesJsonSerializer().fromMap(data['coordinates']);

    return coordinates;
  }
}