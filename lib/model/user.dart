import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:json_annotation/json_annotation.dart';
import 'package:munch/util/app.dart';

part 'user.g.dart';

enum SocialProvider { GOOGLE, FACEBOOK, APPLE }

enum Gender {
@JsonValue("NOANSWER") NOANSWER,
@JsonValue("MALE") MALE,
@JsonValue("FEMALE") FEMALE,
@JsonValue("OTHER") OTHER
}

@JsonSerializable()
class User {
  @JsonKey(ignore: true)
  String accessToken;

  @JsonKey(name: 'pushInfo', nullable: true)
  PushNotificationsInfo pushNotificationsInfo;

  @JsonKey(name: 'userId', nullable: false)
  String uid;
  @JsonKey(nullable: false)
  String email;
  @JsonKey(nullable: false)
  String displayName;
  @JsonKey(unknownEnumValue: Gender.NOANSWER)
  Gender gender;
  String birthday;
  @JsonKey(nullable: false)
  String imageUrl;

  @JsonKey(ignore: true)
  SocialProvider socialProvider;

  @override
  String toString() {
    return "uid: $uid; displayName: $displayName; gender: $gender; birthday: $birthday";
  }

  static String genderAsString(Gender gender) {
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
    if (string == null) {
      return Gender.NOANSWER;
    }
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
      : this(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      imageUrl: firebaseUser.photoURL,
      accessToken: accessToken);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() {
    return {
      'pushInfo': pushNotificationsInfo,
      'userId': uid,
      'email': email,
      'displayName': displayName,
      'gender': (gender != null) ? genderAsString(gender).toUpperCase() : null,
      'birthday': formattedBirthday(birthday),
      'imageUrl': imageUrl,
    };
  }

  static String formattedBirthday(String birthday) {
    if (birthday == null || birthday.isEmpty) { return null; }
    String year = birthday.substring(birthday.length-4);
    String month = birthday.substring(0, 2);
    String day = birthday.substring(3, 5);
    return year + "-" + month + "-" + day;
  }
}

@JsonSerializable()
class PushNotificationsInfo {
  String deviceId;

  @JsonKey(name: 'pushToken')
  String fcmToken;

  PushNotificationsInfo({this.deviceId, this.fcmToken});

  factory PushNotificationsInfo.fromJson(Map<String, dynamic> json) => _$PushNotificationsInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PushNotificationsInfoToJson(this);
}

