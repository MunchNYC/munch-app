import 'package:flutter/material.dart';
import 'package:munch/service/munch/munch_bloc.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/util/app.dart';
import 'package:munch/widget/screen/home/include/create_join_dialog.dart';
import 'package:munch/widget/screen/home/tabs/munches_tab.dart';
import 'package:munch/widget/screen/home/tabs/profile_tab.dart';
import 'package:munch/widget/util/app_status_bar.dart';
import 'package:munch/widget/util/bottom_app_bar.dart';
import 'package:munch/widget/util/dialog_helper.dart';

class HomeScreen extends StatefulWidget {
  static GlobalKey<NavigatorState> munchesTabNavigator;
  static GlobalKey<NavigatorState> accountTabNavigator;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MunchBloc _munchBloc;

  int _currentIndex = 0;

  final List<GlobalKey<NavigatorState>> _tabs = [HomeScreen.munchesTabNavigator, HomeScreen.accountTabNavigator];

  List<Navigator> _navigators;

  _HomeScreenState() {
    _navigators = [
      Navigator(
        key: HomeScreen.munchesTabNavigator,
        onGenerateRoute: (route) =>
            MaterialPageRoute(settings: route, builder: (context) => MunchesTab(munchBloc: _munchBloc)),
      ),
      Navigator(
          key: HomeScreen.accountTabNavigator,
          onGenerateRoute: (route) => MaterialPageRoute(settings: route, builder: (context) => ProfileTab())),
    ];
  }

  @override
  void initState() {
    // otherwise when we pop until home screen we'll get duplicate exception
    HomeScreen.munchesTabNavigator = GlobalKey<NavigatorState>();
    HomeScreen.accountTabNavigator = GlobalKey<NavigatorState>();

    _munchBloc = MunchBloc();

    super.initState();
  }

  @override
  void dispose() {
    _munchBloc?.close();

    super.dispose();
  }

  GlobalKey<NavigatorState> getCurrentScreen() {
    return _tabs[_currentIndex];
  }

  Future<bool> _onBackButtonPressed(BuildContext context) async {
    GlobalKey<NavigatorState> currentScreen = getCurrentScreen();

    if (currentScreen.currentState.canPop()) {
      // if some route widget also defined onWillPopScope (e.g. modal Dialog), consult it before popping
      await currentScreen.currentState.maybePop();
    }

    // we're manually popping routes above, because of that always return false to prevent double pop
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _onBackButtonPressed(context),
        child: Scaffold(
          backgroundColor: Palette.background,
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: false,
          // this needs to be set there as false, in order to support keyboard on create join dialog without overflowing
          appBar: AppStatusBar.getAppStatusBar(iconBrightness: Brightness.dark),
          body: IndexedStack(index: _currentIndex, children: _navigators),
          bottomNavigationBar:  FABBottomAppBar(
              color: Colors.grey,
              selectedColor: Colors.redAccent,
              onTabSelected: onTabTapped,
              items: [
                FABBottomAppBarItem(
                    iconData: Icons.restaurant,
                    label: App.translate('home_screen.bottom_navigation.munches_tab.title')
                    ),
                FABBottomAppBarItem(
                    iconData: Icons.person_rounded,
                    label: App.translate('home_screen.bottom_navigation.profile_tab.title')
                ),
              ],
              ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                DialogHelper(dialogContent: CreateJoinDialog(munchBloc: _munchBloc), rootNavigator: true).show(context);
              },
              child: Icon(Icons.add, size: 32.0),
              elevation: 2.0,
              backgroundColor: Colors.redAccent,
            ),
          ));
  }

  void onTabTapped(int index) {
    if (_currentIndex == index) {
      GlobalKey<NavigatorState> currentTab = _tabs[index];
      if (currentTab != null) {
        currentTab.currentState.popUntil((route) => route.isFirst);
      }
    }

    setState(() {
      _currentIndex = index;
    });
  }
}
