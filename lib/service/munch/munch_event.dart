import 'package:munch/model/munch.dart';

abstract class MunchEvent {}

class GetMunchesEvent extends MunchEvent {}

class JoinMunchEvent extends MunchEvent {
  String munchCode;

  JoinMunchEvent(this.munchCode);
}

class CreateMunchEvent extends MunchEvent {
  Munch munch;

  CreateMunchEvent(this.munch);
}

class GetDetailedMunchEvent extends MunchEvent {
  String munchId;

  GetDetailedMunchEvent(this.munchId);
}

class GetRestaurantsPageEvent extends MunchEvent {
  String munchId;

  GetRestaurantsPageEvent(this.munchId);
}

abstract class RestaurantSwipeEvent extends MunchEvent{
  String munchId;
  String restaurantId;
  bool liked;

  RestaurantSwipeEvent({this.munchId, this.restaurantId, this.liked});
}
class RestaurantSwipeLeftEvent extends RestaurantSwipeEvent {
  RestaurantSwipeLeftEvent({munchId, restaurantId}): super(munchId: munchId, restaurantId: restaurantId, liked: false);
}

class RestaurantSwipeRightEvent extends RestaurantSwipeEvent {
  RestaurantSwipeRightEvent({munchId, restaurantId}): super(munchId: munchId, restaurantId: restaurantId, liked: true);
}