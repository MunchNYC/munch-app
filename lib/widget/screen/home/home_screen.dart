import 'package:flutter/material.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/widget/screen/home/tabs/account_tab.dart';
import 'package:munch/widget/screen/home/tabs/munches_tab.dart';
import 'package:munch/theme/palette.dart';

class HomeScreen extends StatefulWidget {
  static GlobalKey<NavigatorState> munchesTab;
  static GlobalKey<NavigatorState> accountsTab;

  HomeScreen(){
    munchesTab = GlobalKey<NavigatorState>();
    accountsTab = GlobalKey<NavigatorState>();
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<GlobalKey<NavigatorState>> _tabs = [
      HomeScreen.munchesTab,
      HomeScreen.accountsTab
  ];

  final List<Navigator> _navigators = [
    Navigator(
      key: HomeScreen.munchesTab,
      onGenerateRoute: (route) => MaterialPageRoute(
        settings: route,
        builder: (context) =>  MunchesTab()
      ),
    ),
    Navigator(
        key: HomeScreen.accountsTab,
        onGenerateRoute: (route) => MaterialPageRoute(
          settings: route,
          builder: (context) => AccountTab()
        )
    ),
  ];

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
              selectedIconTheme: IconThemeData(color: Palette.ternaryDark),
              unselectedIconTheme: IconThemeData(color: Palette.primary),
              selectedLabelStyle: AppTextStyle.style(AppTextStylePattern.body2, fontWeight: FontWeight.w600, fontSizeOffset: 1.0),
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
