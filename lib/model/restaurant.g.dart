// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Restaurant _$RestaurantFromJson(Map<String, dynamic> json) {
  return Restaurant(
    id: json['id'] as String,
    name: json['name'] as String,
    categories: (json['categories'] as List)
            ?.map((e) => e == null
                ? null
                : RestaurantCategory.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
    workingHours: (json['hours'] as List)
            ?.map((e) => e == null
                ? null
                : WorkingHours.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
    coordinates:
        Coordinates.fromJson(json['coordinates'] as Map<String, dynamic>),
    city: json['city'] as String,
    state: json['state'] as String,
    country: json['country'] as String,
    address: json['address'] as String,
    zipCode: json['zipCode'] as String,
    phoneNumber: json['phoneNumber'] as String,
    priceSymbol: json['price'] as String,
    rating: (json['rating'] as num).toDouble(),
    photoUrls:
        (json['photos'] as List)?.map((e) => e as String)?.toList() ?? [],
    reviewsNumber: json['reviewCount'] as int,
    timezone: json['timezone'] as String,
    url: json['url'] as String,
    usersWhoLiked:
        (json['usersWhoLiked'] as List)?.map((e) => e as String)?.toList() ??
            [],
  )
    ..mapsUrl = json['mapsUrl'] as String
    ..deliverZeroUrl = json['deliverZeroUrl'] as String;
}

Map<String, dynamic> _$RestaurantToJson(Restaurant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'categories': instance.categories,
      'hours': instance.workingHours,
      'coordinates': instance.coordinates,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'address': instance.address,
      'zipCode': instance.zipCode,
      'phoneNumber': instance.phoneNumber,
      'price': instance.priceSymbol,
      'rating': instance.rating,
      'photos': instance.photoUrls,
      'reviewCount': instance.reviewsNumber,
      'timezone': instance.timezone,
      'url': instance.url,
      'mapsUrl': instance.mapsUrl,
      'deliverZeroUrl': instance.deliverZeroUrl,
      'usersWhoLiked': instance.usersWhoLiked,
    };

RestaurantCategory _$RestaurantCategoryFromJson(Map<String, dynamic> json) {
  return RestaurantCategory(
    alias: json['alias'] as String,
    title: json['title'] as String,
  );
}

Map<String, dynamic> _$RestaurantCategoryToJson(RestaurantCategory instance) =>
    <String, dynamic>{
      'alias': instance.alias,
      'title': instance.title,
    };

WorkingHours _$WorkingHoursFromJson(Map<String, dynamic> json) {
  return WorkingHours(
    dayOfWeek: json['dayOfWeek'] as String,
    workingTimes: (json['times'] as List)
            ?.map((e) => e == null
                ? null
                : WorkingTimes.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
  );
}

Map<String, dynamic> _$WorkingHoursToJson(WorkingHours instance) =>
    <String, dynamic>{
      'dayOfWeek': instance.dayOfWeek,
      'times': instance.workingTimes,
    };

WorkingTimes _$WorkingTimesFromJson(Map<String, dynamic> json) {
  return WorkingTimes(
    open: json['open'] as String,
    closed: json['closed'] as String,
  );
}

Map<String, dynamic> _$WorkingTimesToJson(WorkingTimes instance) =>
    <String, dynamic>{
      'open': instance.open,
      'closed': instance.closed,
    };
