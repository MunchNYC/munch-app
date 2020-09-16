import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'restaurant_category.jser.dart';

// Better name for this is just "Category" but it will have conflict with Flutter class
class RestaurantCategory{
  String alias;

  String title;

  @override
  String toString() {
    return "alias: $alias; title: $title";
  }

  RestaurantCategory({this.alias, this.title});
}

@GenSerializer()
class RestaurantCategoryJsonSerializer extends Serializer<RestaurantCategory> with _$RestaurantCategoryJsonSerializer {}