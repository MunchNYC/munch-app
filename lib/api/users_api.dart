import 'package:firebase_auth/firebase_auth.dart';
import 'package:munch/model/user.dart';

import 'Api.dart';

class UsersApi extends Api{
  Future<User> fetchUserById(String userId) async {
    // MOCK-UP
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

    if(firebaseUser == null) return null;

    return User.fromFirebaseUser(firebaseUser: firebaseUser);

    // TODO: use this code when route becomes available
    /*
      String fetchUrl = "/users/$userId";

      var data = await get(fetchUrl);

      print("Response: " + data.toString());

      return UserJsonSerializer().fromMap(data);
    */
  }
}



