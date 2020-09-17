// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$RestaurantJsonSerializer implements Serializer<Restaurant> {
  Serializer<RestaurantCategory> __restaurantCategoryJsonSerializer;
  Serializer<RestaurantCategory> get _restaurantCategoryJsonSerializer =>
      __restaurantCategoryJsonSerializer ??= RestaurantCategoryJsonSerializer();
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
