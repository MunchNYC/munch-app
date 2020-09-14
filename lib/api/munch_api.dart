import 'package:munch/model/munch.dart';

import 'api.dart';

class MunchApi extends Api {
  Future<List<Munch>> getMunches() async {
    String getUrl = "/munches";

    var data = await get(getUrl);

    List<Munch> munchesList = List<Munch>.from(data['compactMunches'].map((munchData){
      return MunchJsonSerializer().fromMap(munchData);
    }));

    return munchesList;
  }

  Future<String> exchangeMunchCode(String munchCode) async {
    String postUrl = "/code";

    Map<String, dynamic> fields = {
      "munchCode": munchCode,
    };

    var data = await post(postUrl, fields);

    String munchId = data['munchId'];

    return munchId;
  }

  Future<Munch> joinMunch(String munchId) async {
    String postUrl = "/join?munchId=$munchId";

    Map<String, dynamic> fields = {
      "munchId": munchId,
    };

    var data = await post(postUrl, fields);

    Munch munch = MunchJsonSerializer().fromMap(data['munchDetailed']);

    return munch;
  }
}