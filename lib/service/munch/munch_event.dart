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