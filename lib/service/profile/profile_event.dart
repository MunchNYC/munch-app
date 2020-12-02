import 'package:munch/model/user.dart';

abstract class ProfileEvent {}

class UpdatePersonalInformationEvent extends ProfileEvent {
  User user;

  UpdatePersonalInformationEvent({this.user});
}