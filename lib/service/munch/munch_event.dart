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

class GetSwipeRestaurantsPageEvent extends MunchEvent {
  String munchId;

  GetSwipeRestaurantsPageEvent(this.munchId);
}