import 'package:flutter/material.dart';
import 'package:munch/service/munch/munch_bloc.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/widget/screen/home/tabs/munches_tab.dart';
import 'package:munch/widget/screen/home/tabs/profile_tab.dart';
import 'package:munch/widget/util/app_status_bar.dart';

class HomeScreen extends StatefulWidget {
  static GlobalKey<NavigatorState> munchesTabNavigator;
  static GlobalKey<NavigatorState> accountTabNavigator;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MunchBloc _munchBloc;

  int _currentIndex = 0;

  final List<GlobalKey<NavigatorState>> _tabs = [
    HomeScreen.munchesTabNavigator,
    HomeScreen.accountTabNavigator
  ];

  List<Navigator> _navigators;

  _HomeScreenState() {
    _navigators = [
      Navigator(
        key: HomeScreen.munchesTabNavigator,
        onGenerateRoute: (route) => MaterialPageRoute(
            settings: route,
            builder: (context) => MunchesTab(munchBloc: _munchBloc)),
      ),
      Navigator(
          key: HomeScreen.accountTabNavigator,
          onGenerateRoute: (route) => MaterialPageRoute(
              settings: route, builder: (context) => ProfileTab())),
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
            appBar:
                AppStatusBar.getAppStatusBar(iconBrightness: Brightness.dark),
            body: IndexedStack(index: _currentIndex, children: _navigators),
            // new
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(color: Palette.secondaryLight),
                ],
              ),
              child: BottomNavigationBar(
                elevation: 0.0,
                iconSize: 32.0,
                selectedFontSize: AppTextStyle.style(AppTextStylePattern.body2,
                        fontSizeOffset: 1.0)
                    .fontSize,
                unselectedFontSize: AppTextStyle.style(
                        AppTextStylePattern.body2,
                        fontSizeOffset: 1.0)
                    .fontSize,
                backgroundColor: Palette.background,
                selectedItemColor: Palette.primary,
                unselectedItemColor: Palette.primary,
                selectedIconTheme: IconThemeData(color: Palette.ternaryDark),
                unselectedIconTheme: IconThemeData(color: Palette.primary),
                selectedLabelStyle: AppTextStyle.style(
                    AppTextStylePattern.body2,
                    fontWeight: FontWeight.w600,
                    fontSizeOffset: 1.0),
                unselectedLabelStyle: AppTextStyle.style(
                    AppTextStylePattern.body2,
                    fontSizeOffset: 1.0),
                onTap: onTabTapped,
                currentIndex: _currentIndex,
                items: [
                  BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage("assets/icons/munchIcon.png"),
                        size: 32.0),
                    label: App.translate(
                        'home_screen.bottom_navigation.munches_tab.title'),
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: ImageIcon(AssetImage("assets/icons/profile.png"),
                            size: 24.0)),
                    label: App.translate(
                        'home_screen.bottom_navigation.profile_tab.title'),
                  ),
                ],
              ),
            )));
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
