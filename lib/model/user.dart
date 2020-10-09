import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'user.jser.dart';

class User{
  @Field.ignore()
  String accessToken;

  @Alias('userId')
  String uid;

  // nonNullable means - put null conditions (maybe better name is @nullable, this is not logical)
  @nonNullable
  String email;

  String displayName;

  String photoUrl;

  @override
  String toString() {
    return "uid: $uid; displayName: $displayName";
  }

  User({this.uid, this.email, this.displayName, this.photoUrl, this.accessToken = ""});

  User.fromFirebaseUser({final firebase_auth.User firebaseUser, final String accessToken = ""})
      :this(uid: firebaseUser.uid, email: firebaseUser.email, displayName: firebaseUser.displayName, photoUrl: firebaseUser.photoURL, accessToken: accessToken);
}

@GenSerializer()
class UserJsonSerializer extends Serializer<User> with _$UserJsonSerializer {}