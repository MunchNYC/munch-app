import 'package:munch/api/maps_api.dart';
import 'package:munch/google_maps_webservice-0.0.18/places.dart';
import 'package:munch/model/coordinates.dart';
import 'package:uuid/uuid.dart';

class MapsRepo {
  static MapsRepo _instance;
  final MapsApi _mapsApi = MapsApi();

  String _sessionToken;

  MapsRepo._internal();

  factory MapsRepo.getInstance() {
    if (_instance == null) {
      _instance = MapsRepo._internal();
    }
    return _instance;
  }

  String get _currentSessionToken {
    if (_sessionToken == null) {
      _sessionToken = Uuid().v4();
    }
    return _sessionToken;
  }

  void _invalidateUuid() {
    _sessionToken = null;
  }

  Future<PlacesAutocompleteResponse> getAutocomplete(String input, Coordinates coordinates) async {
    print(_sessionToken);
    try {
      PlacesAutocompleteResponse response = await _mapsApi.getAutocomplete(_currentSessionToken, input, coordinates);
      return response;
    } catch (error) {
      throw error;
    }
  }

  Future<PlacesDetailsResponse> getCoordinates(String placeId) async {
    try {
      PlacesDetailsResponse response = await _mapsApi.getCoordinates(_currentSessionToken, placeId);
      _invalidateUuid();
      return response;
    } catch (error) {
      throw error;
    }
  }
}