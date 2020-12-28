import 'package:munch/model/user.dart';

import 'api.dart';

class UsersApi extends Api {
  static const String ENDPOINT_SET_PREFIX = 'users';
  static const int API_VERSION = 1;

  UsersApi() : super(endpointSetPrefix: ENDPOINT_SET_PREFIX, version: API_VERSION);

  // Will return user which already exists in DB, or newly created user
  Future<User> registerUser(User user) async {
    final String postUrl = '/data';

    Map<String, dynamic> fields = user.toJson();

    var data = await post(postUrl, fields);

    return User.fromJson(data['muncher']);
  }

  Future<User> getAuthenticatedUser() async {
    String getUrl = "/data";

    var data = await get(getUrl);

    User user = User.fromJson(data['muncher']);

    return user;
  }

  Future<User> updatePushNotificationsInfo(PushNotificationsInfo pushNotificationsInfo) async {
    final String patchUrl = '/data';

    Map<String, dynamic> fields = Map.of({
      "pushInfo": pushNotificationsInfo.toJson(),
    });

    var data = await patch(patchUrl, fields);

    User user = User.fromJson(data['muncher']);

    return user;
  }

  /// Available fields to patch: [displayName], [imageUrl], [email], [gender], [birthday]
  /// [gender] options: MALE, FEMALE, OTHER, NOANSWER
  /// [birthday] required format: YYYY-MM-DD
  Future<User> updatePersonalInfo(Map<String, dynamic> fields) async {
    final String patchUrl = '/data';

    print("updating personal info with fields: " + fields.toString());

    var data = await patch(patchUrl, fields);
    User returnedUser = User.fromJson(data['muncher']);

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
