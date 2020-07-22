import 'package:flutter/material.dart';
import 'package:munch/bottom_tab.dart';
import 'package:munch/munch_map.dart';
import 'package:munch/munch_swipe_screen.dart';
import 'account_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    MunchMap(),
    MunchSwipeScreen(),
    AccountScreen()
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: 896, width: 414, allowFontScaling: true);
    return Scaffold(
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.search),
            title: new Text('Maps'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.group),
            title: new Text('Munch Bunch'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            title: new Text('Account'),
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
