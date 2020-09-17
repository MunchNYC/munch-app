import 'package:flutter/material.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/widget/screen/home/tabs/munches_tab.dart';
import 'package:munch/theme/dimensions.dart';
import 'package:munch/theme/palette.dart';
import 'account_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  static final GlobalKey<NavigatorState> _munchesTab = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _accountsTab = GlobalKey<NavigatorState>();

  final List<GlobalKey<NavigatorState>> _tabs = [
      _munchesTab,
      _accountsTab
  ];

  final List<Navigator> _navigators = [
    Navigator(
      key: _munchesTab,
      onGenerateRoute: (route) => MaterialPageRoute(
        settings: route,
        builder: (context) =>  MunchesTab()
      ),
    ),
    Navigator(
        key: _accountsTab,
        onGenerateRoute: (route) => MaterialPageRoute(
          settings: route,
          builder: (context) => Text("a") // TODO: AccountScreen()
        )
    ),
  ];

  GlobalKey<NavigatorState> getCurrentScreen() {
    return _tabs[_currentIndex];
  }

  Future _onBackButtonPressed(BuildContext context) async {
    GlobalKey<NavigatorState> currentScreen = getCurrentScreen();

    if (currentScreen.currentState.canPop()) {
      currentScreen.currentState.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _onBackButtonPressed(context),
        child: Scaffold(
          backgroundColor: Palette.background,
          body: IndexedStack(index: _currentIndex, children: _navigators),// new
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Palette.secondaryLight
                ),
              ],
            ),
            child: BottomNavigationBar(
              elevation: 0.0,
              iconSize: 32.0,
              selectedFontSize: AppTextStyle.style(AppTextStylePattern.body2, fontSizeOffset: 1.0).fontSize,
              unselectedFontSize: AppTextStyle.style(AppTextStylePattern.body2, fontSizeOffset: 1.0).fontSize,
              backgroundColor: Palette.background,
              selectedItemColor: Palette.primary,
              unselectedItemColor: Palette.primary,
              selectedIconTheme: IconThemeData(color: Palette.secondaryDark),
              unselectedIconTheme: IconThemeData(color: Palette.primary),
              selectedLabelStyle: AppTextStyle.style(AppTextStylePattern.body2, fontWeight: FontWeight.bold, fontSizeOffset: 1.0),
              unselectedLabelStyle: AppTextStyle.style(AppTextStylePattern.body2, fontSizeOffset: 1.0),
              onTap: onTabTapped,
              currentIndex: _currentIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.people_outline),
                  title: Text(App.translate('home_screen.bottom_navigation.tab1.title')),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  title: Text(App.translate('home_screen.bottom_navigation.tab2.title')),
                ),
              ],
            ),
          )
        )
    );
  }

  void onTabTapped(int index) {
    if (_currentIndex == index) {
      _tabs[index].currentState.popUntil((route) => route.isFirst);
    }

    setState(() {
      _currentIndex = index;
    });
  }
}
