import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:munch/model/coordinates.dart';
import 'package:munch/model/restaurant_category.dart';

part 'restaurant.jser.dart';

class Restaurant{
  String id;

  String name;

  List<RestaurantCategory> categories;

  Coordinates coordinates;

  String city;

  String state;

  String country;

  String address;

  String zipCode;

  String phoneNumber;

  @Alias('price')
  String priceSymbol;

  double rating;

  @Alias('photos')
  List<String> photoUrls;

  @Alias('reviewCount')
  int reviewsNumber;

  @override
  String toString() {
    return "id: $id; name: $name;";
  }
}

@GenSerializer()
class RestaurantJsonSerializer extends Serializer<Restaurant> with _$RestaurantJsonSerializer {}