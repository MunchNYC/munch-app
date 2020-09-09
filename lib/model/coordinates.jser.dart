// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coordinates.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$CoordinatesJsonSerializer implements Serializer<Coordinates> {
  @override
  Map<String, dynamic> toMap(Coordinates model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'latitude', model.latitude);
    setMapValue(ret, 'longitude', model.longitude);
    return ret;
  }

  @override
  Coordinates fromMap(Map map) {
    if (map == null) return null;
    final obj = Coordinates();
    obj.latitude = map['latitude'] as double;
    obj.longitude = map['longitude'] as double;
    return obj;
  }
}
