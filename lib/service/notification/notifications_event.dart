abstract class NotificationsEvent {}

class MunchDataChangedNotificationsEvent extends NotificationsEvent{
  String munchId;

  MunchDataChangedNotificationsEvent({this.munchId});
}

class DecisionMadeNotificationEvent extends MunchDataChangedNotificationsEvent {
  DecisionMadeNotificationEvent({String munchId}): super(munchId: munchId);
}

class NewRestaurantNotificationEvent extends MunchDataChangedNotificationsEvent {
  NewRestaurantNotificationEvent({String munchId}): super(munchId: munchId);
}

class NewMuncherNotificationEvent extends MunchDataChangedNotificationsEvent {
  NewMuncherNotificationEvent({String munchId}): super(munchId: munchId);
}