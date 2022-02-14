import 'package:flutter/material.dart';
import 'package:smartrestaurant/HomePageScreen.dart';
import 'package:smartrestaurant/Items.dart';
import 'package:smartrestaurant/ProfilePage.dart';

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _current = 0;

  final pages = [
    HomePageScreen(),
    ItemPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 20,
        unselectedFontSize: 10,
        selectedFontSize: 12,

        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          this.setState(() {
            _current = value;
          });
        }, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
              icon: new Icon(Icons.fireplace), label: "Orders"),
          BottomNavigationBarItem(
              icon: new Icon(Icons.food_bank), label: "Items"),
          BottomNavigationBarItem(
              icon: new Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: _current,
      ),
      body: pages[_current],
    );
  }
}
