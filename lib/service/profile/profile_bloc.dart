import 'package:bloc/bloc.dart';
import 'profile_state.dart';
import 'profile_event.dart';


class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState());

  @override
  void onTransition(Transition<ProfileEvent, ProfileState> transition) {
    print(transition.toString());
    super.onTransition(transition);
  }

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {

  }
}