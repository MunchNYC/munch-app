import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'user.jser.dart';

enum SocialProvider{
  GOOGLE, FACEBOOK, APPLE
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

  String displayName;

  @nonNullable
  String imageUrl;

  @Field.ignore()
  SocialProvider socialProvider;

  @override
  String toString() {
    return "uid: $uid; displayName: $displayName";
  }

  User({this.uid, this.email, this.displayName, this.imageUrl, this.accessToken = ""});

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