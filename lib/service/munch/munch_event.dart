import 'package:munch/model/munch.dart';

abstract class MunchEvent {}

class GetMunchesEvent extends MunchEvent {}

class GetHistoricalMunchesPageEvent extends MunchEvent {
  GetHistoricalMunchesPageEvent();
}

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

abstract class RestaurantSwipeEvent extends MunchEvent {
  String munchId;
  String restaurantId;
  bool liked;

  RestaurantSwipeEvent({this.munchId, this.restaurantId, this.liked});
}

class RestaurantSwipeLeftEvent extends RestaurantSwipeEvent {
  RestaurantSwipeLeftEvent({munchId, restaurantId})
      : super(munchId: munchId, restaurantId: restaurantId, liked: false);
}

class RestaurantSwipeRightEvent extends RestaurantSwipeEvent {
  RestaurantSwipeRightEvent({munchId, restaurantId})
      : super(munchId: munchId, restaurantId: restaurantId, liked: true);
}

class NoMoreImagesCarouselEvent extends MunchEvent {
  bool isLeftSideTapped;

  NoMoreImagesCarouselEvent({this.isLeftSideTapped});
}

class SaveMunchPreferencesEvent extends MunchEvent {
  Munch munch;

  SaveMunchPreferencesEvent({this.munch});
}

class KickMemberEvent extends MunchEvent {
  String munchId;
  String userId;

  KickMemberEvent({this.munchId, this.userId});
}

class LeaveMunchEvent extends MunchEvent {
  String munchId;

  LeaveMunchEvent({this.munchId});
}

class NewMunchRestaurantEvent extends MunchEvent {
  String munchId;

  NewMunchRestaurantEvent({this.munchId});
}

class ReviewMunchEvent extends MunchEvent {
  // if review is requested on app opened
  bool forcedReview;
  MunchReviewValue munchReviewValue;
  String munchId;

  ReviewMunchEvent(
      {this.munchReviewValue, this.munchId, this.forcedReview = false});
}
