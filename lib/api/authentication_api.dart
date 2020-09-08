import 'package:firebase_auth/firebase_auth.dart';
import 'package:munch/model/user.dart';
import 'Api.dart';

class AuthenticationApi extends Api {
  Future<User> registerSocial(final String email) async {
    // MOCK-UP
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

    if(firebaseUser == null) return null;

    return User.fromFirebaseUser(firebaseUser: firebaseUser);

    // TODO: use this code when route becomes available
   /*
   final String postUrl = '/auth/register-social';

    Map<String, String> fields =
    {
      "email": email,
    };

    Map headers = await generateHeaders(authRequired: false);

    return post(postUrl, fields, headers).then((registeredUserData) {
      return UserJsonSerializer().fromMap(registeredUserData);
    });
    */
  }
}
