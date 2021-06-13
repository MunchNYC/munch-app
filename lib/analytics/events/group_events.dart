import 'package:munch/analytics/events/event.dart';

class GroupEvents {
  static Event createGroupButtonTapped(int time) {
    return Event('CreateGroupButtonTapped', {'time': time.toString()});
  }

  static Event groupCreated(String groupId) {
    return Event('GroupCreated', {'groupId': groupId});
  }

  static Event groupMatched(String groupId) {
    return Event('GroupMatched', {'groupId': groupId});
  }

  static Event groupUnmatched(String groupId) {
    return Event('GroupUnmatched', {'groupId': groupId});
  }
}
