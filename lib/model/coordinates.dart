import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'coordinates.jser.dart';

class Coordinates {
  double latitude;
  double longitude;

  @override
  String toString() {
    return "latitude: $latitude; longitude: $longitude";
  }

  Coordinates({this.latitude, this.longitude});
}

@GenSerializer()
class CoordinatesJsonSerializer extends Serializer<Coordinates> with _$CoordinatesJsonSerializer {}