import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/repository/munch_repository.dart';
import 'package:munch/service/munch/munch_state.dart';
import 'package:munch/service/notification/notifications_event.dart';
import 'package:munch/service/notification/notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc() : super(NotificationsState());

  final MunchRepo _munchRepo = MunchRepo.getInstance();

  @override
  void onTransition(Transition<NotificationsEvent, NotificationsState> transition) {
    print(transition.toString());
    super.onTransition(transition);
  }

  @override
  Stream<NotificationsState> mapEventToState(NotificationsEvent event) async* {
    if(event is MunchDataChangedNotificationsEvent){
      yield* _getDetailedMunch(event.munchId);
    } else if(event is KickMemberNotificationEvent){
      yield* _currentUserKickedFromMunch(event.munchId);
    }
  }

  Stream<NotificationsState> _getDetailedMunch(String munchId) async* {
    yield DetailedMunchNotificationState.loading();

    try {
      Munch munch = await _munchRepo.getDetailedMunch(munchId);

      yield DetailedMunchNotificationState.ready(data: munch);
    } catch (error) {
      print("Munch fetching failed from foreground notification: " + error.toString());
      yield DetailedMunchNotificationState.failed(message: error.toString());
    }
  }

  Stream<NotificationsState> _currentUserKickedFromMunch(String munchId) async* {
    yield CurrentUserKickedNotificationState.ready(data: munchId);
  }
}