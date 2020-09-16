// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'munch.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$MunchJsonSerializer implements Serializer<Munch> {
  final _timestampProcessor = const TimestampProcessor();
  Serializer<Coordinates> __coordinatesJsonSerializer;
  Serializer<Coordinates> get _coordinatesJsonSerializer =>
      __coordinatesJsonSerializer ??= CoordinatesJsonSerializer();
  Serializer<User> __userJsonSerializer;
  Serializer<User> get _userJsonSerializer =>
      __userJsonSerializer ??= UserJsonSerializer();
  Serializer<Filter> __filterJsonSerializer;
  Serializer<Filter> get _filterJsonSerializer =>
      __filterJsonSerializer ??= FilterJsonSerializer();
  @override
  Map<String, dynamic> toMap(Munch model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'link', model.link);
    setMapValue(ret, 'name', model.name);
    setMapValue(ret, 'coordinates',
        _coordinatesJsonSerializer.toMap(model.coordinates));
    setMapValueIfNotNull(ret, 'radius', model.radius);
    setMapValueIfNotNull(
        ret,
        'members',
        codeNonNullIterable(model.members,
            (val) => _userJsonSerializer.toMap(val as User), []));
    setMapValueIfNotNull(
        ret,
        'blacklistFilters',
        codeNonNullIterable(model.blacklistFilters,
            (val) => _filterJsonSerializer.toMap(val as Filter), []));
    setMapValueIfNotNull(
        ret,
        'whitelistFilters',
        codeNonNullIterable(model.whitelistFilters,
            (val) => _filterJsonSerializer.toMap(val as Filter), []));
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
        _timestampProcessor.deserialize(map['creationTimestamp'] as int) ??
            getJserDefault('creationTimestamp') ??
            obj.creationTimestamp;
    obj.coordinates =
        _coordinatesJsonSerializer.fromMap(map['coordinates'] as Map);
    obj.radius = map['radius'] as int ?? getJserDefault('radius') ?? obj.radius;
    obj.members = codeNonNullIterable<User>(map['members'] as Iterable,
            (val) => _userJsonSerializer.fromMap(val as Map), <User>[]) ??
        getJserDefault('members') ??
        obj.members;
    obj.blacklistFilters = codeNonNullIterable<Filter>(
            map['blacklistFilters'] as Iterable,
            (val) => _filterJsonSerializer.fromMap(val as Map), <Filter>[]) ??
        getJserDefault('blacklistFilters') ??
        obj.blacklistFilters;
    obj.whitelistFilters = codeNonNullIterable<Filter>(
            map['whitelistFilters'] as Iterable,
            (val) => _filterJsonSerializer.fromMap(val as Map), <Filter>[]) ??
        getJserDefault('whitelistFilters') ??
        obj.whitelistFilters;
    return obj;
  }
}
