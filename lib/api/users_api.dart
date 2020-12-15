import 'package:munch/model/user.dart';
import 'package:munch/util/app.dart';
import 'api.dart';

class UsersApi extends Api {
  static const String ENDPOINT_SET_PREFIX = 'users';
  static const int API_VERSION = 1;

  UsersApi(): super(endpointSetPrefix: ENDPOINT_SET_PREFIX, version: API_VERSION);

  // Will return user which already exists in DB, or newly created user
  Future<User> registerUser(User user) async {
    final String postUrl = '/data';

    Map<String, dynamic> fields = UserJsonSerializer().toMap(user);

    var data = await post(postUrl, fields);

    return UserJsonSerializer().fromMap(data['muncher']);
  }

  Future<User> getAuthenticatedUser() async {
    String getUrl = "/data";

    var data = await get(getUrl);

    User user = UserJsonSerializer().fromMap(data['muncher']);

    return user;
  }

  Future<User> updatePushNotificationsInfo(PushNotificationsInfo pushNotificationsInfo) async {
    final String patchUrl = '/data';

    Map<String, dynamic> fields = Map.of({
      "pushInfo": PushNotificationsInfoJsonSerializer().toMap(pushNotificationsInfo),
    });

    var data = await patch(patchUrl, fields);

    User user = UserJsonSerializer().fromMap(data['muncher']);

    return user;
  }

  /// Available fields to patch
  /// displayName, imageUrl, email, gender, birthday
  Future<User> updatePersonalInfo(Map<String, dynamic> fields) async {
    final String patchUrl = '/data';

    print("updating personal info with fields: " + fields.toString());

    var data = await patch(patchUrl, fields);
    User returnedUser = UserJsonSerializer().fromMap(data['muncher']);

    return returnedUser;
  }

  Future signOut(String deviceId) async {
    final String postUrl = '/logout';

    Map<String, String> fields = Map.of({
      'deviceId': deviceId,
    });

    await post(postUrl, fields);
  }
}