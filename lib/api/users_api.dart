import 'package:munch/model/user.dart';
import 'api.dart';

class UsersApi extends Api {
  static const String ENDPOINT_SET_PREFIX = 'users';
  static const int API_VERSION = 1;

  UsersApi(): super(endpointSetPrefix: ENDPOINT_SET_PREFIX, version: API_VERSION);

  // Will return user which already exists in DB, or newly created user
  Future<User> registerUser(User user) async {
    final String postUrl = ''; // TODO

    Map<String, dynamic> fields = UserJsonSerializer().toMap(user);

    var data = await post(postUrl, fields);

    return UserJsonSerializer().fromMap(data['user']);
  }

  Future<User> getAuthenticatedUser() async {
    String getUrl = ""; // TODO

    var data = await get(getUrl);

    User user = UserJsonSerializer().fromMap(data['user']);

    return user;
  }

  Future<User> updateFCMToken(String deviceId, String fcmToken) async {
    final String patchUrl = ''; // TODO

    Map<String, String> fields = Map.of({
      'deviceId': deviceId,
      'fcmToken': fcmToken
    });

    var data = await patch(patchUrl, fields);

    User user = UserJsonSerializer().fromMap(data['user']);

    return user;
  }


  Future signOut(String deviceId) async {
    final String postUrl = ''; // TODO

    Map<String, String> fields = Map.of({
      'deviceId': deviceId,
    });

    await post(postUrl, fields);
  }
}