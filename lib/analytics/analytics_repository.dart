import 'package:munch/analytics/analytics_api.dart';
import 'package:munch/analytics/events/sharing_events.dart';
import 'package:munch/analytics/events/swipe_screen_events.dart';
import 'package:munch/analytics/events/group_events.dart';
import 'events/onboarding_events.dart';

class AnalyticsRepo {
  static AnalyticsRepo _instance;

  AnalyticsRepo._internal();

  factory AnalyticsRepo.getInstance() {
    if (_instance == null) _instance = AnalyticsRepo._internal();
    return _instance;
  }

  //region swipingEvents
  void trackImpressions(String restaurantId, Map<String, int> impressions) {
    Analytics.getInstance().track(SwipeScreenEvents.photoImpression(restaurantId, impressions));
  }

  void trackSwipeScreenLeftSwipe(String restaurantId) {
    Analytics.getInstance().track(SwipeScreenEvents.swipedLeft(restaurantId));
  }

  void trackSwipeScreenRightSwipe(String restaurantId) {
    Analytics.getInstance().track(SwipeScreenEvents.swipedRight(restaurantId));
  }
  //endregion

  //region inviteTracking
  void trackShareGroup(String munchId, String groupName, ShareGroupType shareGroupType) {
    Analytics.getInstance().track(UserSharingEvents.shareGroup(munchId, groupName, shareGroupType));
  }

  void trackInviteFriend() {
    Analytics.getInstance().track(UserSharingEvents.inviteFriend());
  }
  //endregion

  //region groupEvents
  void createGroupButtonTapped(int tapHour){
    Analytics.getInstance().track(GroupEvents.createGroupButtonTapped(tapHour));
  }

  void trackGroupCreation(String munchId){
    Analytics.getInstance().track(GroupEvents.groupCreated(munchId));
  }

  void trackGroupMatched(String munchId){
    Analytics.getInstance().track(GroupEvents.groupMatched(munchId));
  }

  void trackGroupUnmatched(String munchId){
    Analytics.getInstance().track(GroupEvents.groupUnmatched(munchId));
  }
  //endregion

  //region onBoardingEvents
  void onboardingSkipTapped(int page) {
    Analytics.getInstance().track(OnboardingEvents.skipTapped(page));
  }

  void onboardingNextTapped(int page) {
    Analytics.getInstance().track(OnboardingEvents.nextTapped(page));
  }

  void onboardingCompletionCTATapped() {
    Analytics.getInstance().track(OnboardingEvents.completionCTATapped());
  }

  void onboardingCompletionManuallyTapped() {
    Analytics.getInstance().track(OnboardingEvents.completionManuallyTapped());
  }

  void onboardingCompletionWithDeeplinkTapped() {
    Analytics.getInstance().track(OnboardingEvents.deeplinkCompletionTapped());
  }
  //endregion
}
