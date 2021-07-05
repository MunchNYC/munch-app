import 'package:flutter/material.dart';
import 'package:flutter_sliding_tutorial/flutter_sliding_tutorial.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/navigation_helper.dart';
import 'package:munch/widget/util/custom_button.dart';

class TutorialPage extends StatelessWidget {
  final int page;
  final ValueNotifier<double> notifier;
  final Image image;
  final String title;
  final String body;
  final PageController pageController;

  TutorialPage(this.page, this.notifier, this.image, this.title, this.body, this.pageController);

  @override
  Widget build(BuildContext context) {
    return SlidingPage(
      notifier: notifier,
      page: page,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
        child: Container(
        child: Column(
          children: [
            SizedBox(height: 80),
            SlidingContainer(child: image, offset: 0),
            SizedBox(height: 40),
            SlidingContainer(
              offset: 250,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 16),
            SlidingContainer(
              offset: 100,
              child: Text(
                body,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff717171),
                ),
              ),
            ),
            SizedBox(height: 40),
            SlidingContainer(offset: 75, child: _nextButton(context))
          ],
        ),
      ),
      ),
    );
  }

  Widget _nextButton(BuildContext context) {
    if (page == 0 || page == 1) {
      return Padding(
          padding: EdgeInsets.only(right: 24.0),
          child: Align(
              alignment: Alignment.centerRight,
              child: CustomButton(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                borderRadius: 4.0,
                color: Colors.redAccent,
                content: Text("Next"),
                onPressedCallback: () => { pageController.animateToPage(page+1, duration: Duration(milliseconds: 600), curve: Curves.easeInOut)},
              )));
    } else if (page == 2) {
      return Column(
          children: <Widget>[

            Center(
              child: CustomButton(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                borderRadius: 4.0,
                color: Colors.redAccent,
                content: Text(App.translate("onboarding_location.accept_permissions.button.title")),
                onPressedCallback: () {
                  NavigationHelper.navigateToMapScreen(context, munchName: "_munchName", addToBackStack: false);
                  },
              )),
            SizedBox(height: 8.0),
            Center(
                child: CustomButton(
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  borderRadius: 4.0,
                  color: Colors.white,
                  textColor: Colors.redAccent,
                  flat: true,
                  content: Text(App.translate("onboarding_location.deny_permissions.button.title")),
                  onPressedCallback: () => { NavigationHelper.navigateToMapScreen(context, munchName: "_munchName", addToBackStack: true) },
                )),
      ]);
    }
  }
}
