import 'package:http/http.dart';
import 'package:munch/model/coordinates.dart';
import 'core.dart';
import 'utils.dart';

const _placesUrl = '/place';

/// https://developers.google.com/places/web-service/
class GoogleMapsPlaces extends GoogleWebService {
  GoogleMapsPlaces({
    String apiKey,
    String baseUrl,
    Client httpClient,
  }) : super(
            apiKey: apiKey,
            baseUrl: baseUrl,
            url: _placesUrl,
            httpClient: httpClient);
}

class PlaceDetails {}

class PlacesDetailsResponse extends GoogleResponse<PlaceDetails> {
  final Coordinates coordinates;

  PlacesDetailsResponse(
    this.coordinates,
    {String status,
    String errorMessage,
    PlaceDetails result}
  ) : super(
          status,
          errorMessage,
          result,
        );

  factory PlacesDetailsResponse.fromJson(Map json) => json != null
      ? PlacesDetailsResponse(json['coordinates']) : null;
}

class PlacesAutocompleteResponse extends GoogleResponseStatus {
  final List<Prediction> predictions;

  PlacesAutocompleteResponse(
    this.predictions,
    {String status,
    String errorMessage}
  ) : super(
          status,
          errorMessage,
        );

  factory PlacesAutocompleteResponse.fromJson(Map json) => json != null
      ? PlacesAutocompleteResponse(
          json['autocompleteResults']
              ?.map((p) => Prediction.fromJson(p))
              ?.toList()
              ?.cast<Prediction>())
      : null;
}

class Prediction {
  final String placeId;
  final String displayString;

  Prediction(this.placeId, this.displayString);

  factory Prediction.fromJson(Map json) => json != null
      ? Prediction(
          json['placeId'],
          json['displayString'],
        )
      : null;
}