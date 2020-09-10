// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'munch.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$MunchJsonSerializer implements Serializer<Munch> {
  final _timestampProcessor = const TimestampProcessor();
  @override
  Map<String, dynamic> toMap(Munch model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'id', model.id);
    setMapValue(ret, 'code', model.code);
    setMapValue(ret, 'name', model.name);
    setMapValue(ret, 'numberOfMembers', model.numberOfMembers);
    setMapValue(ret, 'creationTimestamp',
        _timestampProcessor.serialize(model.creationTimestamp));
    return ret;
  }

  @override
  Munch fromMap(Map map) {
    if (map == null) return null;
    final obj = Munch();
    obj.id = map['id'] as String;
    obj.code = map['code'] as String;
    obj.name = map['name'] as String;
    obj.numberOfMembers = map['numberOfMembers'] as int;
    obj.creationTimestamp =
        _timestampProcessor.deserialize(map['creationTimestamp'] as int);
    return obj;
  }
}
