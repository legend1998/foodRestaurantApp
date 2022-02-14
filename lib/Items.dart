import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartrestaurant/services/Service.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({Key? key}) : super(key: key);

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  bool loading = true;
  late StreamSubscription cancelStream;
  late String _restId;
  List items = [];

  void loaddata() async {
    _restId = await Service.getRestaurantId();
    //restaurantId
    var orderStream = FirebaseFirestore.instance
        .collection("restaurant")
        .doc(_restId)
        .collection("items")
        .snapshots();

    cancelStream = orderStream.listen((event) {
      print(event.docs.length);
      this.setState(() {
        items = event.docs
            .map((e) => {
                  ...e.data(),
                  "id": e.id,
                })
            .toList();
      });
    });
    this.setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    cancelStream.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loaddata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          title: Text(
            "My Food Items",
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: ListView(
              children: items
                  .map((it) => Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              child: CachedNetworkImage(
                                imageUrl: it["imageUrl"],
                              ),
                            ),
                            Expanded(
                                child: Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    it["name"],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(it["price"]),
                                      Text(it["unit"]),
                                    ],
                                  )
                                ],
                              ),
                            )),
                            Container(
                              child: TextButton(
                                style: ButtonStyle(
                                    backgroundColor: (it["available"] ?? false)
                                        ? MaterialStateProperty.all(
                                            Colors.green)
                                        : MaterialStateProperty.all(Colors.red),
                                    foregroundColor: MaterialStateProperty.all(
                                        Colors.white)),
                                child: Text((it["available"] ?? false)
                                    ? "Available"
                                    : "Not Available"),
                                onPressed: () async {
                                  //do nothing
                                  print(it["id"]);
                                  FirebaseFirestore.instance
                                      .collection("restaurant")
                                      .doc(_restId)
                                      .collection("items")
                                      .doc(it["id"])
                                      .update({
                                    "available": !(it["available"] ?? false)
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList()),
        ));
  }
}
