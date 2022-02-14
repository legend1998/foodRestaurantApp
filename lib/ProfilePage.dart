import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartrestaurant/LoginScreen.dart';
import 'package:smartrestaurant/services/Service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var _rest;
  bool loading = true;
  void loadData() async {
    String restId = await Service.getRestaurantId();
    _rest = await FirebaseFirestore.instance
        .collection("restaurant")
        .doc(restId)
        .get()
        .then((value) => {...?value.data(), "id": value.id});
    this.setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Container(
                      height: 300,
                      color: Colors.red,
                      width: MediaQuery.of(context).size.width,
                      child: CachedNetworkImage(
                        imageUrl: _rest["imageUrl"],
                      )),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                          (route) => false);
                    },
                    subtitle: Text("log out from this app"),
                    title: Text("Log Out"),
                  ),
                ],
              ),
      ),
    );
  }
}
