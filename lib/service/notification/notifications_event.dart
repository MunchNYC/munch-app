abstract class NotificationsEvent {}

class TimestampedNotificationsEvent extends NotificationsEvent{
  DateTime timestampUTC;

  TimestampedNotificationsEvent(this.timestampUTC);
}

class MunchDataChangedNotificationsEvent extends TimestampedNotificationsEvent{
  String munchId;

  MunchDataChangedNotificationsEvent({this.munchId, DateTime timestampUTC}): super(timestampUTC);
}

class DecisionMadeNotificationEvent extends MunchDataChangedNotificationsEvent {
  DecisionMadeNotificationEvent({String munchId, DateTime timestampUTC}): super(munchId: munchId, timestampUTC: timestampUTC);
}

class NewRestaurantNotificationEvent extends MunchDataChangedNotificationsEvent {
  NewRestaurantNotificationEvent({String munchId, DateTime timestampUTC}): super(munchId: munchId, timestampUTC: timestampUTC);
}

class NewMuncherNotificationEvent extends MunchDataChangedNotificationsEvent {
  NewMuncherNotificationEvent({String munchId, DateTime timestampUTC}): super(munchId: munchId, timestampUTC: timestampUTC);
}

class KickMemberNotificationEvent extends TimestampedNotificationsEvent {
  String munchId;

  KickMemberNotificationEvent({this.munchId, DateTime timestampUTC}): super(timestampUTC);
}