import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munch/service/munch/munch_bloc.dart';
import 'package:munch/service/munch/munch_event.dart';
import 'package:munch/service/munch/munch_state.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/widget/screen/home/tabs/munches_tab.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/widget/screen/home/tabs/profile_tab.dart';
import 'package:munch/widget/screen/splash/include/splash_logo.dart';
import 'package:munch/widget/util/app_status_bar.dart';

class HomeScreen extends StatefulWidget {
  static GlobalKey<NavigatorState> munchesTabNavigator;
  static GlobalKey<NavigatorState> accountTabNavigator;

  bool fromSplashScreen;

  HomeScreen({this.fromSplashScreen = false}) {
    munchesTabNavigator = GlobalKey<NavigatorState>();
    accountTabNavigator = GlobalKey<NavigatorState>();
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MunchBloc _munchBloc;

  double _screenOpacity = 1;

  int _currentIndex = 0;

  final List<GlobalKey<NavigatorState>> _tabs = [
    HomeScreen.munchesTabNavigator,
    HomeScreen.accountTabNavigator
  ];

  List<Navigator> _navigators;

  // must be set as an argument because we cannot use widget.fromSplashScreen in field initializer
  _HomeScreenState() {
    _navigators = [
      Navigator(
        key: HomeScreen.munchesTabNavigator,
        onGenerateRoute: (route) => MaterialPageRoute(
            settings: route,
            builder: (context) =>
                MunchesTab(munchBloc: _munchBloc)
        ),
      ),
      Navigator(
          key: HomeScreen.accountTabNavigator,
          onGenerateRoute: (route) => MaterialPageRoute(
              settings: route, builder: (context) => ProfileTab()
          )
      ),
    ];
  }

  @override
  void initState() {
    _munchBloc = MunchBloc();

    if(widget.fromSplashScreen){
      _screenOpacity = 0;
    }

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
        child: _munchBlocBuilder()
    );
  }

  Widget _munchBlocBuilder(){
    return BlocBuilder<MunchBloc, MunchState>(
        cubit: _munchBloc,
        buildWhen: (MunchState previous, MunchState current) => widget.fromSplashScreen && (current is MunchesFetchingState),
        builder: (BuildContext context, MunchState state) => _buildHomeView(context, state)
    );
  }

  Widget _buildHomeView(BuildContext context, MunchState state){
    bool showSplashLogo = false;

    if(widget.fromSplashScreen && (state.initial || state.loading)){
      showSplashLogo = true;
    } else{
      // show splash just first time
      widget.fromSplashScreen = false;
      _screenOpacity = 1;
    }

    return Stack(
      children: [
        AnimatedOpacity(
          opacity: 1.0 - _screenOpacity,
          duration: Duration(milliseconds: 3000),
          curve: Curves.easeInOut,
          child: SplashLogo(isHero: false),
        ),
        AnimatedOpacity(
          opacity: _screenOpacity,
          curve: Curves.linear,
          duration: Duration(milliseconds: 1500),
          child:Container(
            color: Palette.background,
            child: _renderScreen()
          )
        )
      ],
    );
  }

  Widget _renderScreen(){
    return Scaffold(
          backgroundColor: Palette.background,
          extendBodyBehindAppBar: true,
          appBar: AppStatusBar.getAppStatusBar(iconBrightness: Brightness.dark),
          body: IndexedStack(
              index: _currentIndex, children: _navigators), // new
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
                  label: App.translate('home_screen.bottom_navigation.munches_tab.title'),
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: ImageIcon(AssetImage("assets/icons/profile.png"),
                          size: 24.0)),
                  label: App.translate('home_screen.bottom_navigation.profile_tab.title'),
                ),
              ],
            ),
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
