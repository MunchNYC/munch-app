import 'package:munch/model/user.dart';

abstract class ProfileEvent {}

class UpdatePersonalInformationEvent extends ProfileEvent {
  Map<String, dynamic> fields;

  UpdatePersonalInformationEvent({this.fields});
}