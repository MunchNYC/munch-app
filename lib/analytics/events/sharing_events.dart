import 'package:munch/analytics/events/event.dart';
import 'package:munch/util/utility.dart';

class UserSharingEvents {
  static Event shareGroup(String munchId, String groupName, ShareGroupType shareGroupType) {
    return Event('ShareGroupPostCreate', {
      'groupId': munchId,
      'groupName': groupName,
      'shareLocation': Utility.convertEnumValueToString(shareGroupType)
    });
  }

  static Event inviteFriend() {
    return Event('InviteFriend', {});
  }
}

enum ShareGroupType { POST_CREATE, GROUP_OPTIONS }
