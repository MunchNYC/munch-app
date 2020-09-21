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
  Serializer<Restaurant> __restaurantJsonSerializer;
  Serializer<Restaurant> get _restaurantJsonSerializer =>
      __restaurantJsonSerializer ??= RestaurantJsonSerializer();
  @override
  Map<String, dynamic> toMap(Munch model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'name', model.name);
    setMapValue(ret, 'coordinates',
        _coordinatesJsonSerializer.toMap(model.coordinates));
    setMapValue(ret, 'radius', model.radius);
    return ret;
  }

  @override
  Munch fromMap(Map map) {
    if (map == null) return null;
    final obj = Munch();
    obj.id = map['id'] as String;
    obj.code = map['code'] as String;
    obj.name = map['name'] as String;
    obj.hostUserId =
        map['host'] as String ?? getJserDefault('hostUserId') ?? obj.hostUserId;
    obj.numberOfMembers = map['numberOfMembers'] as int ??
        getJserDefault('numberOfMembers') ??
        obj.numberOfMembers;
    obj.creationTimestamp =
        _timestampProcessor.deserialize(map['creationTimestamp'] as int) ??
            getJserDefault('creationTimestamp') ??
            obj.creationTimestamp;
    obj.coordinates =
        _coordinatesJsonSerializer.fromMap(map['coordinates'] as Map);
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
    obj.matchedRestaurant =
        _restaurantJsonSerializer.fromMap(map['matchedRestaurant'] as Map) ??
            getJserDefault('matchedRestaurant') ??
            obj.matchedRestaurant;
    return obj;
  }
}
