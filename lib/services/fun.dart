import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartrestaurant/HomePageScreen.dart';
import 'package:smartrestaurant/ProfilePage.dart';

void onItemTappedForBottomNavigationBar(int index, BuildContext context) {
  switch (index) {
    case 0:
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePageScreen()),
          (route) => false);

      break;

    case 3:
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ProfilePage()));
      break;
    default:
  }
}
