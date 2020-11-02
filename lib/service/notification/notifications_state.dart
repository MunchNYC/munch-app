import 'package:munch/service/util/super_state.dart';

class NotificationsState extends SuperState {
  NotificationsState({initial = true, loading = false, hasError = false, message = ""}):super(initial: initial, loading: loading, hasError: hasError, message: message);

  NotificationsState.ready({data}):super.ready(data: data);
  NotificationsState.loading({message = ""}):super.loading(message: message);
  NotificationsState.failed({message = ""}):super.failed(message: message);
}

class DetailedMunchNotificationState extends NotificationsState {
  DetailedMunchNotificationState({initial = true, loading = false, hasError = false, message = ""}):super(initial: initial, loading: loading, hasError: hasError, message: message);

  DetailedMunchNotificationState.ready({data}):super.ready(data: data);
  DetailedMunchNotificationState.loading({message = ""}):super.loading(message: message);
  DetailedMunchNotificationState.failed({message = ""}):super.failed(message: message);
}