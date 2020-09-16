// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_category.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

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
