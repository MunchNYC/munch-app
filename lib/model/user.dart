import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'user.jser.dart';

enum SocialProvider{
  GOOGLE, FACEBOOK, APPLE
}

enum Gender {
  MALE, FEMALE, OTHER, NOTSPECIFIED
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
  String gender;

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

  User({this.uid, this.email, this.displayName, this.gender, this.birthday, this.imageUrl, this.accessToken = ""});

  User.fromFirebaseUser({final firebase_auth.User firebaseUser, final String accessToken = ""})
      :this(uid: firebaseUser.uid, email: firebaseUser.email, displayName: firebaseUser.displayName, imageUrl: firebaseUser.photoURL, accessToken: accessToken);
}

@GenSerializer()
class UserJsonSerializer extends Serializer<User> with _$UserJsonSerializer {}

class PushNotificationsInfo{
  String deviceId;

  @Alias('pushToken')
  String fcmToken;

  PushNotificationsInfo({this.deviceId, this.fcmToken});
}

@GenSerializer()
class PushNotificationsInfoJsonSerializer extends Serializer<PushNotificationsInfo> with _$PushNotificationsInfoJsonSerializer {}