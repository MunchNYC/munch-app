// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'munch.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$MunchJsonSerializer implements Serializer<Munch> {
  final _timestampProcessor = const TimestampProcessor();
  final _munchStatusProcessor = const MunchStatusProcessor();
  Serializer<Coordinates> __coordinatesJsonSerializer;
  Serializer<Coordinates> get _coordinatesJsonSerializer =>
      __coordinatesJsonSerializer ??= CoordinatesJsonSerializer();
  Serializer<User> __userJsonSerializer;
  Serializer<User> get _userJsonSerializer =>
      __userJsonSerializer ??= UserJsonSerializer();
  Serializer<MunchMemberFilters> __munchMemberFiltersJsonSerializer;
  Serializer<MunchMemberFilters> get _munchMemberFiltersJsonSerializer =>
      __munchMemberFiltersJsonSerializer ??= MunchMemberFiltersJsonSerializer();
  Serializer<MunchFilters> __munchFiltersJsonSerializer;
  Serializer<MunchFilters> get _munchFiltersJsonSerializer =>
      __munchFiltersJsonSerializer ??= MunchFiltersJsonSerializer();
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
    obj.munchMemberFilters = _munchMemberFiltersJsonSerializer
            .fromMap(map['munchMemberFilters'] as Map) ??
        getJserDefault('munchMemberFilters') ??
        obj.munchMemberFilters;
    obj.munchFilters =
        _munchFiltersJsonSerializer.fromMap(map['munchFilters'] as Map) ??
            getJserDefault('munchFilters') ??
            obj.munchFilters;
    obj.matchedRestaurant =
        _restaurantJsonSerializer.fromMap(map['matchedRestaurant'] as Map) ??
            getJserDefault('matchedRestaurant') ??
            obj.matchedRestaurant;
    obj.matchedRestaurantName = map['matchedRestaurantName'] as String ??
        getJserDefault('matchedRestaurantName') ??
        obj.matchedRestaurantName;
    obj.receivePushNotifications = map['receivePushNotifications'] as bool ??
        getJserDefault('receivePushNotifications') ??
        obj.receivePushNotifications;
    obj.munchStatus = _munchStatusProcessor.deserialize(map['state'] as String);
    return obj;
  }
}

abstract class _$MunchMemberFiltersJsonSerializer
    implements Serializer<MunchMemberFilters> {
  @override
  Map<String, dynamic> toMap(MunchMemberFilters model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'whitelist',
        codeIterable(model.whitelistFiltersKeys, (val) => val as String));
    setMapValue(ret, 'blacklist',
        codeIterable(model.blacklistFiltersKeys, (val) => val as String));
    return ret;
  }

  @override
  MunchMemberFilters fromMap(Map map) {
    if (map == null) return null;
    final obj = MunchMemberFilters();
    obj.whitelistFiltersKeys = codeIterable<String>(
        map['whitelist'] as Iterable, (val) => val as String);
    obj.blacklistFiltersKeys = codeIterable<String>(
        map['blacklist'] as Iterable, (val) => val as String);
    return obj;
  }
}

abstract class _$MunchFiltersJsonSerializer
    implements Serializer<MunchFilters> {
  Serializer<MunchGroupFilter> __munchGroupFilterJsonSerializer;
  Serializer<MunchGroupFilter> get _munchGroupFilterJsonSerializer =>
      __munchGroupFilterJsonSerializer ??= MunchGroupFilterJsonSerializer();
  @override
  Map<String, dynamic> toMap(MunchFilters model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(
        ret,
        'blacklist',
        codeIterable(
            model.blacklist,
            (val) => _munchGroupFilterJsonSerializer
                .toMap(val as MunchGroupFilter)));
    setMapValue(
        ret,
        'whitelist',
        codeIterable(
            model.whitelist,
            (val) => _munchGroupFilterJsonSerializer
                .toMap(val as MunchGroupFilter)));
    return ret;
  }

  @override
  MunchFilters fromMap(Map map) {
    if (map == null) return null;
    final obj = MunchFilters();
    obj.blacklist = codeIterable<MunchGroupFilter>(map['blacklist'] as Iterable,
        (val) => _munchGroupFilterJsonSerializer.fromMap(val as Map));
    obj.whitelist = codeIterable<MunchGroupFilter>(map['whitelist'] as Iterable,
        (val) => _munchGroupFilterJsonSerializer.fromMap(val as Map));
    return obj;
  }
}

abstract class _$MunchGroupFilterJsonSerializer
    implements Serializer<MunchGroupFilter> {
  @override
  Map<String, dynamic> toMap(MunchGroupFilter model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'key', model.key);
    setMapValue(
        ret, 'userIds', codeIterable(model.userIds, (val) => val as String));
    return ret;
  }

  @override
  MunchGroupFilter fromMap(Map map) {
    if (map == null) return null;
    final obj = MunchGroupFilter();
    obj.key = map['key'] as String;
    obj.userIds = codeIterable<String>(
        map['userIds'] as Iterable, (val) => val as String);
    return obj;
  }
}
