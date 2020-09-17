import 'package:munch/api/munch_api.dart';
import 'package:munch/model/munch.dart';

class MunchRepo {
  static MunchRepo _instance;

  MunchRepo._internal();

  factory MunchRepo.getInstance() {
    if (_instance == null) {
      _instance = MunchRepo._internal();
    }
    return _instance;
  }

  MunchApi _munchApi = MunchApi();

  Future<List<Munch>> getMunches() async{
      return await _munchApi.getMunches();
  }

  Future<Munch> joinMunch(String munchCode) async{
    String munchId = await _munchApi.getMunchIdForCode(munchCode);

    Munch munch = await _munchApi.joinMunch(munchId);

    return munch;
  }

  Future<Munch> createMunch(Munch munch) async{
    Munch createdMunch = await _munchApi.createMunch(munch);

    return createdMunch;
  }
}