import 'package:flutter/material.dart';
import 'package:munch/bottom_tab.dart';
import 'package:munch/munch_swipe_screen.dart';


class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 1;
  final List<Widget> _children = [
    BottomTabWdiget(Colors.white),
    MunchSwipeScreen(),
  int _currentIndex = 0;
  final List<Widget> _children = [
    BottomTabWdiget(Colors.white),
    BottomTabWdiget(Colors.deepOrange),
    BottomTabWdiget(Colors.green)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Munch'),
      ),
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
            title: new Text('Profile'),
            icon: new Icon(Icons.person),
            title: new Text('Profile'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.group),
            title: new Text('Munch Bunch'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            title: new Text('Profile'),
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
