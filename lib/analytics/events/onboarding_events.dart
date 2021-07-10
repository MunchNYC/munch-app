import 'package:munch/analytics/events/event.dart';

class OnboardingEvents {
  static Event skipTapped(int page) {
    return Event('OnBoardingSkipTapped', {'page': '$page'});
  }

  static Event nextTapped(int page) {
    return Event('OnBoardingNextTapped', {'page': '$page'});
  }

  static Event completionCTATapped() {
    return Event('OnBoardingCompletionCTATapped', {});
  }

  static Event completionManuallyTapped() {
    return Event('OnBoardingCompletionManuallyTapped', {});
  }

  static Event deeplinkCompletionTapped() {
    return Event('OnboardingCompletedWithDeeplinkEntry', {});
  }
}