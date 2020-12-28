import 'package:munch/google_maps_webservice-0.0.18/places.dart';
import 'package:munch/model/coordinates.dart';
import 'package:munch/model/response/autocomplete_responses.dart';

import 'api.dart';

class MapsApi extends Api {
  static const String ENDPOINT_SET_PREFIX = 'map/search';
  static const int API_VERSION = 1;

  MapsApi() : super(endpointSetPrefix: ENDPOINT_SET_PREFIX, version: API_VERSION);

  Future<PlacesAutocompleteResponse> getAutocomplete(String sessionToken, String input, Coordinates coordinates) async {
    String postUrl = "/autocomplete";

    Map<String, dynamic> body = {
      "sessionToken": sessionToken,
      "coordinates": {
        "longitude": coordinates.longitude,
        "latitude": coordinates.latitude
      },
      "input": input
    };
    var data = await post(postUrl, body);

    AutocompleteResponses getAutocompleteResponses = AutocompleteResponses.fromJson(data);

    List<Prediction> predictions = [];

    getAutocompleteResponses.autocompleteResponses.forEach((element) {
      predictions.add(Prediction(element.placeId, element.displayString));
    });

    return PlacesAutocompleteResponse(predictions);
  }

  Future<PlacesDetailsResponse> getCoordinates(String sessionToken, String placeId) async {
    String postUrl = "/coordinates";

    Map<String, dynamic> body = {
      "sessionToken": sessionToken,
      "placeId": placeId
    };
    var data = await post(postUrl, body);

    Coordinates coordinates = Coordinates.fromJson(data['coordinates']);

    return PlacesDetailsResponse(coordinates);
  }
}