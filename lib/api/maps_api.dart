import 'dart:html';

import 'package:munch/model/coordinates.dart';

import 'api.dart';

class MapsApi extends Api {
  static const String ENDPOINT_SET_PREFIX = 'map/search';
  static const int API_VERSION = 1;

  MapsApi() : super(endpointSetPrefix: ENDPOINT_SET_PREFIX, version: API_VERSION);

  Future<AutocompleteResponse> getAutocomplete(AutocompleteRequest body) async {
    String postUrl = "/autocomplete";

    var data = await post(postUrl, body);

    AutocompleteResponse getAutocompleteResponse = GetAutocompleteResponseJsonSerializer().fromMap(data);
  }

  Future<AutocompleteCoordinatesReponse> getCoordinates(String placeId) async {
    String postUrl = "/coordinates";

    Map<String, dynamic> body = {
      "sessionToken": "84baf23a-f119-4e93-9acb-e2b2ff849f8a",
      "placeId": placeId
    };
    var data = await post(postUrl, body);

    Coordinates coordinates = CoordinatesJsonSerializer().fromMap(data['coordinates']);

    return coordinates;
  }
}