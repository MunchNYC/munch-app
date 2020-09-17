abstract class MunchEvent {}

class GetMunchesEvent extends MunchEvent {}

class JoinMunchEvent extends MunchEvent {
  String munchCode;

  JoinMunchEvent(this.munchCode);
}