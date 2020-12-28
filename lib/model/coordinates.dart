import 'package:json_annotation/json_annotation.dart';

part 'coordinates.g.dart';

@JsonSerializable(nullable: false)
class Coordinates {
  double latitude;
  double longitude;

  @override
  String toString() {
    return "latitude: $latitude; longitude: $longitude";
  }

  bool equals(Coordinates coordinates) {
    return this.latitude == coordinates.latitude && this.longitude == coordinates.longitude;
  }

  Coordinates({this.latitude, this.longitude});

  factory Coordinates.fromJson(Map<String, dynamic> json) => _$CoordinatesFromJson(json);

  Map<String, dynamic> toJson() => _$CoordinatesToJson(this);
}
