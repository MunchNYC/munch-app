import 'package:flutter/material.dart';
import 'package:flutter_sliding_tutorial/flutter_sliding_tutorial.dart';
import 'package:munch/util/app.dart';
import 'package:munch/widget/screen/onboarding/tutorial_page.dart';

class SlidingTutorial extends StatefulWidget {
  final ValueNotifier<double> notifier;
  final int pageCount;

  const SlidingTutorial({this.notifier, this.pageCount});

  @override
  State<StatefulWidget> createState() => _SlidingTutorial();
}

class _SlidingTutorial extends State<SlidingTutorial> {
  var _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    /// Listen to [PageView] position updates.
    _pageController.addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackgroundColor(
      colors: [Colors.white],
        pageController: _pageController,
        pageCount: widget.pageCount,
        child: Container(
            child: PageView(
                controller: _pageController,
                children: List<Widget>.generate(
                    widget.pageCount, (index) => _getPageByIndex(index)))));
  }

  /// Create different [SlidingPage] for indexes.
  Widget _getPageByIndex(int index) {
    switch (index % 3) {
      case 0:
        return TutorialPage(
            index,
            widget.notifier,
            Image(image: AssetImage('assets/images/onboarding/greet.png')),
            App.translate("onboarding_greeting.title"),
            App.translate("onboarding_greeting.description")
        );
      case 1:
        return TutorialPage(index, widget.notifier, Image(image: AssetImage('assets/images/onboarding/engage.png')), "Swipe Match Eat!", "We make it fun and easy");
      case 2:
        return TutorialPage(index, widget.notifier, Image(image: AssetImage('assets/images/onboarding/location.png')), "Tasty Neighborhood", "We make it fun and easy");
      default:
        throw ArgumentError("Unknown position: $index");
    }
  }

  /// Notify [SlidingPage] about current page changes.
  _onScroll() {
    widget.notifier.value = _pageController.page ?? 0;
  }
}
