import 'package:firebase_auth/firebase_auth.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'user.jser.dart';

class User{
  String accessToken;

  String uid;

  String email;

  String displayName;

  @override
  String toString() {
    return "uid: $uid; displayName: $displayName; accessToken: $accessToken;";
  }

  User({this.uid, this.email, this.displayName, this.accessToken = ""});

  User.fromFirebaseUser({final FirebaseUser firebaseUser, final String accessToken = ""})
      :this(uid: firebaseUser.uid, email: firebaseUser.email, displayName: firebaseUser.displayName, accessToken: accessToken);
}

@GenSerializer()
class UserJsonSerializer extends Serializer<User> with _$UserJsonSerializer {}