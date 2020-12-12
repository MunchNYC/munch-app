import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:munch/model/processors/gender_processor.dart';
import 'package:munch/util/app.dart';

part 'user.jser.dart';

enum SocialProvider{
  GOOGLE, FACEBOOK, APPLE
}

enum Gender {
  NOANSWER, MALE, FEMALE, OTHER
}

class User{
  @Field.ignore()
  String accessToken;

  @Alias('pushInfo', isNullable: false) // Field.encode not generating good JSON serializer for some reason
  PushNotificationsInfo pushNotificationsInfo;

  @Alias('userId')
  String uid;

  // nonNullable means - put null conditions (maybe better name is @nullable, this is not logical)
  @nonNullable
  String email;

  @nonNullable
  String displayName;

  @nonNullable
  Gender gender;

  @nullable
  String birthday;

  @nonNullable
  String imageUrl;

  @Field.ignore()
  SocialProvider socialProvider;

  @override
  String toString() {
    return "uid: $uid; displayName: $displayName; gender: $gender; birthday: $birthday";
  }

  static String genderToString(Gender gender) {
    switch (gender) {
      case Gender.MALE:
        return App.translate("personal_information_screen.gender.male.text");
      case Gender.FEMALE:
        return App.translate("personal_information_screen.gender.female.text");
      case Gender.OTHER:
        return App.translate("personal_information_screen.gender.other.text");
      case Gender.NOANSWER:
        return App.translate("personal_information_screen.gender.no_answer.text");
      default:
        return null;
    }
  }

  static Gender stringToGender(String string) {
    if (string.toUpperCase() == "MALE") {
      return Gender.MALE;
    } else if (string.toUpperCase() == "FEMALE") {
      return Gender.FEMALE;
    } else if (string != null) {
      return Gender.OTHER;
    } else {
      return Gender.NOANSWER;
    }
  }

  User({this.uid, this.email, this.displayName, this.gender, this.birthday, this.imageUrl, this.accessToken = ""});

  User.fromFirebaseUser({final firebase_auth.User firebaseUser, final String accessToken = ""})
      :this(uid: firebaseUser.uid, email: firebaseUser.email, displayName: firebaseUser.displayName, imageUrl: firebaseUser.photoURL, accessToken: accessToken);
}

@GenSerializer(fields: const {
  // dontEncode must be specified here if we define custom processor, isNullable means that it CAN be nullable
  'gender': const Field(processor: GenderProcessor(), dontEncode: true, isNullable: true)
})
class UserJsonSerializer extends Serializer<User> with _$UserJsonSerializer {}

class PushNotificationsInfo{
  String deviceId;

  @Alias('pushToken')
  String fcmToken;

  PushNotificationsInfo({this.deviceId, this.fcmToken});
}

@GenSerializer()
class PushNotificationsInfoJsonSerializer extends Serializer<PushNotificationsInfo> with _$PushNotificationsInfoJsonSerializer {}