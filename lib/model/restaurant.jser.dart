// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$RestaurantJsonSerializer implements Serializer<Restaurant> {
  Serializer<RestaurantCategory> __restaurantCategoryJsonSerializer;
  Serializer<RestaurantCategory> get _restaurantCategoryJsonSerializer =>
      __restaurantCategoryJsonSerializer ??= RestaurantCategoryJsonSerializer();
  Serializer<WorkingHours> __workingHoursJsonSerializer;
  Serializer<WorkingHours> get _workingHoursJsonSerializer =>
      __workingHoursJsonSerializer ??= WorkingHoursJsonSerializer();
  Serializer<Coordinates> __coordinatesJsonSerializer;
  Serializer<Coordinates> get _coordinatesJsonSerializer =>
      __coordinatesJsonSerializer ??= CoordinatesJsonSerializer();
  @override
  Map<String, dynamic> toMap(Restaurant model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'id', model.id);
    setMapValue(ret, 'name', model.name);
    setMapValue(
        ret,
        'categories',
        codeIterable(
            model.categories,
            (val) => _restaurantCategoryJsonSerializer
                .toMap(val as RestaurantCategory)));
    setMapValue(
        ret,
        'hours',
        codeIterable(model.workingHours,
            (val) => _workingHoursJsonSerializer.toMap(val as WorkingHours)));
    setMapValue(ret, 'coordinates',
        _coordinatesJsonSerializer.toMap(model.coordinates));
    setMapValue(ret, 'city', model.city);
    setMapValue(ret, 'state', model.state);
    setMapValue(ret, 'country', model.country);
    setMapValue(ret, 'address', model.address);
    setMapValue(ret, 'zipCode', model.zipCode);
    setMapValue(ret, 'phoneNumber', model.phoneNumber);
    setMapValue(ret, 'price', model.priceSymbol);
    setMapValue(ret, 'rating', model.rating);
    setMapValue(
        ret, 'photos', codeIterable(model.photoUrls, (val) => val as String));
    setMapValue(ret, 'reviewCount', model.reviewsNumber);
    return ret;
  }

  @override
  Restaurant fromMap(Map map) {
    if (map == null) return null;
    final obj = Restaurant();
    obj.id = map['id'] as String;
    obj.name = map['name'] as String;
    obj.categories = codeIterable<RestaurantCategory>(
        map['categories'] as Iterable,
        (val) => _restaurantCategoryJsonSerializer.fromMap(val as Map));
    obj.workingHours = codeIterable<WorkingHours>(map['hours'] as Iterable,
        (val) => _workingHoursJsonSerializer.fromMap(val as Map));
    obj.coordinates =
        _coordinatesJsonSerializer.fromMap(map['coordinates'] as Map);
    obj.city = map['city'] as String;
    obj.state = map['state'] as String;
    obj.country = map['country'] as String;
    obj.address = map['address'] as String;
    obj.zipCode = map['zipCode'] as String;
    obj.phoneNumber = map['phoneNumber'] as String;
    obj.priceSymbol = map['price'] as String;
    obj.rating = map['rating'] as double;
    obj.photoUrls =
        codeIterable<String>(map['photos'] as Iterable, (val) => val as String);
    obj.reviewsNumber = map['reviewCount'] as int;
    return obj;
  }
}

abstract class _$RestaurantCategoryJsonSerializer
    implements Serializer<RestaurantCategory> {
  @override
  Map<String, dynamic> toMap(RestaurantCategory model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'alias', model.alias);
    setMapValue(ret, 'title', model.title);
    return ret;
  }

  @override
  RestaurantCategory fromMap(Map map) {
    if (map == null) return null;
    final obj = RestaurantCategory();
    obj.alias = map['alias'] as String;
    obj.title = map['title'] as String;
    return obj;
  }
}

abstract class _$WorkingHoursJsonSerializer
    implements Serializer<WorkingHours> {
  Serializer<WorkingTimes> __workingTimesJsonSerializer;
  Serializer<WorkingTimes> get _workingTimesJsonSerializer =>
      __workingTimesJsonSerializer ??= WorkingTimesJsonSerializer();
  @override
  Map<String, dynamic> toMap(WorkingHours model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'dayOfWeek', model.dayOfWeek);
    setMapValue(
        ret,
        'times',
        codeIterable(model.workingTimes,
            (val) => _workingTimesJsonSerializer.toMap(val as WorkingTimes)));
    return ret;
  }

  @override
  WorkingHours fromMap(Map map) {
    if (map == null) return null;
    final obj = WorkingHours();
    obj.dayOfWeek = map['dayOfWeek'] as String;
    obj.workingTimes = codeIterable<WorkingTimes>(map['times'] as Iterable,
        (val) => _workingTimesJsonSerializer.fromMap(val as Map));
    return obj;
  }
}

abstract class _$WorkingTimesJsonSerializer
    implements Serializer<WorkingTimes> {
  @override
  Map<String, dynamic> toMap(WorkingTimes model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'open', model.open);
    setMapValue(ret, 'closed', model.closed);
    return ret;
  }

  @override
  WorkingTimes fromMap(Map map) {
    if (map == null) return null;
    final obj = WorkingTimes();
    obj.open = map['open'] as String;
    obj.closed = map['closed'] as String;
    return obj;
  }
}
