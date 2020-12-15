import 'package:bloc/bloc.dart';
import 'package:munch/model/user.dart';
import 'package:munch/repository/user_repository.dart';
import 'profile_state.dart';
import 'profile_event.dart';


class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState());

  final UserRepo _userRepo = UserRepo.getInstance();

  @override
  void onTransition(Transition<ProfileEvent, ProfileState> transition) {
    print(transition.toString());
    super.onTransition(transition);
  }

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is UpdatePersonalInformationEvent) {
      yield* updatePersonalInformation(event.fields);
    }
  }

  Stream<ProfileState> updatePersonalInformation(Map<String, dynamic> fields) async* {
    yield UpdatePersonalInformationState.loading();

    try {
      User updatedUser = await _userRepo.updateCurrentUser(fields);
      yield UpdatePersonalInformationState.ready(data: updatedUser);
    } catch (error) {
      print("Updating Personal Information failed: " + error.toString());
      yield UpdatePersonalInformationState.failed(exception: error, message: error.toString());
    }
  }
}