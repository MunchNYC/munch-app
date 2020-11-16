import 'package:flutter_test/flutter_test.dart';
import 'package:munch/config/app_config.dart';
import 'package:munch/model/coordinates.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/model/restaurant.dart';
import 'package:munch/model/user.dart';
import 'package:munch/repository/user_repository.dart';

import '../util/test_util.dart';

Munch mockCompactMunch(){
  Munch munch = new Munch();

  munch.id = "1";
  munch.code = "ABCDEF";
  munch.name = "Munch";
  munch.numberOfMembers = 3;
  munch.creationTimestamp = DateTime(2020, 1, 1, 1, 0);
  munch.munchStatus = MunchStatus.UNDECIDED;
  munch.matchedRestaurantName = null;

  return munch;
}

Munch mockPartialDetailedMunch(Munch compactMunch){
  Munch munch = new Munch();

  munch.id = compactMunch.id;
  munch.code = compactMunch.code;
  munch.name = compactMunch.name + " changed";
  munch.munchStatus = MunchStatus.DECIDED;
  munch.matchedRestaurant = Restaurant(id: "1", name: "Test Restaurant");
  munch.coordinates = Coordinates(latitude: 45.0, longitude: 45.0);
  munch.munchFilters = MunchFilters(blacklist: [MunchGroupFilter(key: 'a', userIds: ['1', '2']), MunchGroupFilter(key: 'b', userIds: ['2', '3'])], whitelist: [MunchGroupFilter(key: 'a', userIds: ['3'])]);
  munch.munchMemberFilters = MunchMemberFilters(blacklistFiltersKeys: ['b'], whitelistFiltersKeys: ['a']);
  munch.hostUserId = '3';
  munch.receivePushNotifications = true;
  munch.members = []; // Partial munch

  return munch;
}

void testPartialMerge(Munch compactMunch, Munch compactMunchCopy, Munch detailedMunch){
  expect(compactMunchCopy.id, detailedMunch.id);
  expect(compactMunchCopy.code, detailedMunch.code);
  expect(compactMunchCopy.name, detailedMunch.name);
  expect(compactMunchCopy.munchStatus, detailedMunch.munchStatus);
  expect(compactMunchCopy.munchStatusChanged, detailedMunch.munchStatus != compactMunch.munchStatus);
  expect(compactMunchCopy.coordinates, detailedMunch.coordinates);
  expect(compactMunchCopy.munchFilters, detailedMunch.munchFilters);
  expect(compactMunchCopy.munchMemberFilters, detailedMunch.munchMemberFilters);
  expect(compactMunchCopy.hostUserId, detailedMunch.hostUserId);
  expect(compactMunchCopy.receivePushNotifications, detailedMunch.receivePushNotifications);
  expect(compactMunchCopy.members.length, 1);
  expect(compactMunchCopy.members[0], UserRepo.getInstance().currentUser);
  expect(compactMunchCopy.numberOfMembers, compactMunch.numberOfMembers);
  expect(compactMunchCopy.matchedRestaurantName, detailedMunch.matchedRestaurant.name);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Partial merge munch test', () async {
    TestUtil.mockPluginMethodChannel('plugins.flutter.io/package_info', Map.of({}));
    TestUtil.mockPluginMethodChannel('plugins.it_nomads.com/flutter_secure_storage', null);

    await AppConfig.forEnvironment("dev");

    await UserRepo.getInstance().setCurrentUser(User(uid: '3', email: 'test@test.com', displayName: 'Test Current User'));

    Munch compactMunch = mockCompactMunch();
    Munch detailedMunch = mockPartialDetailedMunch(compactMunch);

    Munch compactMunchCopy = mockCompactMunch();
    compactMunchCopy.merge(detailedMunch);

    testPartialMerge(compactMunch, compactMunchCopy, detailedMunch);
  });
}