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
    setMapValue(ret, 'id', passProcessor.serialize(model.id));
    setMapValue(ret, 'name', passProcessor.serialize(model.name));
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
    setMapValue(ret, 'city', passProcessor.serialize(model.city));
    setMapValue(ret, 'state', passProcessor.serialize(model.state));
    setMapValue(ret, 'country', passProcessor.serialize(model.country));
    setMapValue(ret, 'address', passProcessor.serialize(model.address));
    setMapValue(ret, 'zipCode', passProcessor.serialize(model.zipCode));
    setMapValue(ret, 'phoneNumber', passProcessor.serialize(model.phoneNumber));
    setMapValue(ret, 'price', passProcessor.serialize(model.priceSymbol));
    setMapValue(ret, 'rating', model.rating);
    setMapValue(ret, 'photos',
        codeIterable(model.photoUrls, (val) => passProcessor.serialize(val)));
    setMapValue(ret, 'reviewCount', model.reviewsNumber);
    setMapValue(ret, 'timezone', passProcessor.serialize(model.timezone));
    setMapValue(ret, 'url', passProcessor.serialize(model.url));
    setMapValue(
        ret,
        'usersWhoLiked',
        codeIterable(model.usersWhoLiked,
            (val) => passProcessor.serialize(model.usersWhoLiked)));
    return ret;
  }

  @override
  Restaurant fromMap(Map map) {
    if (map == null) return null;
    final obj = Restaurant();
    obj.id = passProcessor.deserialize(map['id']);
    obj.name = passProcessor.deserialize(map['name']);
    obj.categories = codeIterable<RestaurantCategory>(
        map['categories'] as Iterable,
        (val) => _restaurantCategoryJsonSerializer.fromMap(val as Map));
    obj.workingHours = codeIterable<WorkingHours>(map['hours'] as Iterable,
        (val) => _workingHoursJsonSerializer.fromMap(val as Map));
    obj.coordinates =
        _coordinatesJsonSerializer.fromMap(map['coordinates'] as Map);
    obj.city = passProcessor.deserialize(map['city']);
    obj.state = passProcessor.deserialize(map['state']);
    obj.country = passProcessor.deserialize(map['country']);
    obj.address = passProcessor.deserialize(map['address']);
    obj.zipCode = passProcessor.deserialize(map['zipCode']);
    obj.phoneNumber = passProcessor.deserialize(map['phoneNumber']);
    obj.priceSymbol = passProcessor.deserialize(map['price']);
    obj.rating = map['rating'] as double;
    obj.photoUrls = codeIterable<String>(
        map['photos'] as Iterable, (val) => passProcessor.deserialize(val));
    obj.reviewsNumber = map['reviewCount'] as int;
    obj.timezone = passProcessor.deserialize(map['timezone']);
    obj.url = passProcessor.deserialize(map['url']);
    obj.usersWhoLiked = codeIterable<String>(map['usersWhoLiked'] as Iterable,
        (val) => passProcessor.deserialize(val));
    return obj;
  }
}

abstract class _$RestaurantCategoryJsonSerializer
    implements Serializer<RestaurantCategory> {
  @override
  Map<String, dynamic> toMap(RestaurantCategory model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'alias', passProcessor.serialize(model.alias));
    setMapValue(ret, 'title', passProcessor.serialize(model.title));
    return ret;
  }

  @override
  RestaurantCategory fromMap(Map map) {
    if (map == null) return null;
    final obj = RestaurantCategory();
    obj.alias = passProcessor.deserialize(map['alias']);
    obj.title = passProcessor.deserialize(map['title']);
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
    setMapValue(ret, 'dayOfWeek', passProcessor.serialize(model.dayOfWeek));
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
    obj.dayOfWeek = passProcessor.deserialize(map['dayOfWeek']);
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
    setMapValue(ret, 'open', passProcessor.serialize(model.open));
    setMapValue(ret, 'closed', passProcessor.serialize(model.closed));
    return ret;
  }

  @override
  WorkingTimes fromMap(Map map) {
    if (map == null) return null;
    final obj = WorkingTimes();
    obj.open = passProcessor.deserialize(map['open']);
    obj.closed = passProcessor.deserialize(map['closed']);
    return obj;
  }
}
