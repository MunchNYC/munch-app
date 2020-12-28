// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'munch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Munch _$MunchFromJson(Map<String, dynamic> json) {
  return Munch(
    id: json['id'] as String,
    name: json['name'] as String,
    receivePushNotifications: json['receivePushNotifications'] as bool,
    coordinates:
        Coordinates.fromJson(json['coordinates'] as Map<String, dynamic>),
    radius: json['radius'] as int,
  )
    ..code = json['code'] as String
    ..hostUserId = json['host'] as String
    ..numberOfMembers = json['numberOfMembers'] as int
    ..creationTimestamp =
        Munch._dateTimeFromEpochUs(json['creationTimestamp'] as int)
    ..imageUrl = json['imageUrl'] as String
    ..members = (json['members'] as List)
        ?.map(
            (e) => e == null ? null : User.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..munchMemberFilters = json['munchMemberFilters'] == null
        ? null
        : MunchMemberFilters.fromJson(
            json['munchMemberFilters'] as Map<String, dynamic>)
    ..munchFilters = json['munchFilters'] == null
        ? null
        : MunchFilters.fromJson(json['munchFilters'] as Map<String, dynamic>)
    ..matchedRestaurant = json['matchedRestaurant'] == null
        ? null
        : Restaurant.fromJson(json['matchedRestaurant'] as Map<String, dynamic>)
    ..matchedRestaurantName = json['matchedRestaurantName'] as String
    ..munchStatus = _$enumDecode(_$MunchStatusEnumMap, json['state'],
        unknownValue: MunchStatus.HISTORICAL);
}

Map<String, dynamic> _$MunchToJson(Munch instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'host': instance.hostUserId,
      'numberOfMembers': instance.numberOfMembers,
      'creationTimestamp': Munch._dateTimeToEpochUs(instance.creationTimestamp),
      'coordinates': instance.coordinates,
      'radius': instance.radius,
      'imageUrl': instance.imageUrl,
      'members': instance.members,
      'munchMemberFilters': instance.munchMemberFilters,
      'munchFilters': instance.munchFilters,
      'matchedRestaurant': instance.matchedRestaurant,
      'matchedRestaurantName': instance.matchedRestaurantName,
      'receivePushNotifications': instance.receivePushNotifications,
      'state': _$MunchStatusEnumMap[instance.munchStatus],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

const _$MunchStatusEnumMap = {
  MunchStatus.UNDECIDED: 'UNDECIDED',
  MunchStatus.DECIDED: 'DECIDED',
  MunchStatus.UNMODIFIABLE: 'UNMODIFIABLE',
  MunchStatus.HISTORICAL: 'HISTORICAL',
};

MunchMemberFilters _$MunchMemberFiltersFromJson(Map<String, dynamic> json) {
  return MunchMemberFilters(
    whitelistFiltersKeys:
        (json['whitelist'] as List)?.map((e) => e as String)?.toList() ?? [],
    blacklistFiltersKeys:
        (json['blacklist'] as List)?.map((e) => e as String)?.toList() ?? [],
  );
}

Map<String, dynamic> _$MunchMemberFiltersToJson(MunchMemberFilters instance) =>
    <String, dynamic>{
      'whitelist': instance.whitelistFiltersKeys,
      'blacklist': instance.blacklistFiltersKeys,
    };

MunchFilters _$MunchFiltersFromJson(Map<String, dynamic> json) {
  return MunchFilters(
    blacklist: (json['blacklist'] as List)
            ?.map((e) => e == null
                ? null
                : MunchGroupFilter.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
    whitelist: (json['whitelist'] as List)
            ?.map((e) => e == null
                ? null
                : MunchGroupFilter.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
  );
}

Map<String, dynamic> _$MunchFiltersToJson(MunchFilters instance) =>
    <String, dynamic>{
      'blacklist': instance.blacklist,
      'whitelist': instance.whitelist,
    };

MunchGroupFilter _$MunchGroupFilterFromJson(Map<String, dynamic> json) {
  return MunchGroupFilter(
    key: json['key'] as String,
    userIds: (json['userIds'] as List)?.map((e) => e as String)?.toList() ?? [],
  );
}

Map<String, dynamic> _$MunchGroupFilterToJson(MunchGroupFilter instance) =>
    <String, dynamic>{
      'key': instance.key,
      'userIds': instance.userIds,
    };

RequestedReview _$RequestedReviewFromJson(Map<String, dynamic> json) {
  return RequestedReview(
    munchId: json['munchId'] as String,
    imageUrl: json['imageUrl'] as String,
  );
}

Map<String, dynamic> _$RequestedReviewToJson(RequestedReview instance) =>
    <String, dynamic>{
      'munchId': instance.munchId,
      'imageUrl': instance.imageUrl,
    };
