import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sliding_tutorial/flutter_sliding_tutorial.dart';
import 'package:munch/config/constants.dart';
import 'package:munch/widget/screen/onboarding/sliding_tutorial.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  String deepLink;

  OnboardingScreen({this.deepLink});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final ValueNotifier<double> notifier = ValueNotifier(0);
  int pageCount = 3;

  @override
  void didChangeDependencies() {
    _setSharedPreferencesForOnboarding();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              /// [StatefulWidget] with [PageView] and [AnimatedBackgroundColor].
              SlidingTutorial(
                pageCount: pageCount,
                notifier: notifier,
                deepLink: widget.deepLink
              ),

              /// [SlidingIndicator] for [PageView] in [SlidingTutorial].
              Align(
                alignment: Alignment(0, 0.85),
                child: SlidingIndicator(
                  indicatorCount: pageCount,
                  notifier: notifier,
                  activeIndicator: CircleAvatar(child:Icon(Icons.circle, size: 12.0, color: Colors.redAccent), backgroundColor: Colors.transparent),
                  inActiveIndicator: CircleAvatar(child:Icon(Icons.circle, size: 12.0, color: Colors.grey), backgroundColor: Colors.transparent), //Image(image: AssetImage('assets/images/floatingActionButtonImage.png')),
                  margin: 8,
                  sizeIndicator: 12,
                ),
              )
            ],
      )),
    );
  }

  void _setSharedPreferencesForOnboarding() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(StorageKeys.SHOULD_SHOW_ONBOARDING, false);
  }
}
