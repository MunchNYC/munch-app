// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_munches_response.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$GetMunchesResponseJsonSerializer
    implements Serializer<GetMunchesResponse> {
  Serializer<Munch> __munchJsonSerializer;
  Serializer<Munch> get _munchJsonSerializer =>
      __munchJsonSerializer ??= MunchJsonSerializer();
  @override
  Map<String, dynamic> toMap(GetMunchesResponse model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(
        ret,
        'undecidedMunches',
        codeIterable(model.undecidedMunches,
            (val) => _munchJsonSerializer.toMap(val as Munch)));
    setMapValue(
        ret,
        'decidedMunches',
        codeIterable(model.decidedMunches,
            (val) => _munchJsonSerializer.toMap(val as Munch)));
    setMapValue(
        ret,
        'archivedMunches',
        codeIterable(model.archivedMunches,
            (val) => _munchJsonSerializer.toMap(val as Munch)));
    return ret;
  }

  @override
  GetMunchesResponse fromMap(Map map) {
    if (map == null) return null;
    final obj = GetMunchesResponse();
    obj.undecidedMunches = codeIterable<Munch>(
        map['undecidedMunches'] as Iterable,
        (val) => _munchJsonSerializer.fromMap(val as Map));
    obj.decidedMunches = codeIterable<Munch>(map['decidedMunches'] as Iterable,
        (val) => _munchJsonSerializer.fromMap(val as Map));
    obj.archivedMunches = codeIterable<Munch>(
        map['archivedMunches'] as Iterable,
        (val) => _munchJsonSerializer.fromMap(val as Map));
    return obj;
  }
}
