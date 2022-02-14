import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartrestaurant/data/AppUser.dart';
import 'package:smartrestaurant/services/Service.dart';
import 'package:smartrestaurant/services/fun.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  PageController pc = PageController();
  int currentPage = 0;
  bool loading = true;
  late StreamSubscription cancelStream;
  late AppUser _user;
  late String _restId;
  List newOrder = [];

  void loaddata() async {
    _user = await Service.getuser();
    _restId = await Service.getRestaurantId(mobile: _user.phone);
    //restaurantId
    var orderStream = FirebaseFirestore.instance
        .collection("orders")
        .where("restaurantId", isEqualTo: _restId)
        .snapshots();

    cancelStream = orderStream.listen((event) {
      this.setState(() {
        newOrder = event.docs.map((e) => {"id": e.id, ...e.data()}).toList();
      });
    });
    this.setState(() {
      loading = false;
    });
  }

  void prepareConfirm(id) {
    showModalBottomSheet(
      isScrollControlled: false,
      context: context,
      builder: (context) => Wrap(
        direction: Axis.vertical,
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            width: 300,
            margin: EdgeInsets.all(20),
            child: Text(
              "Are you sure You are going to prepare this.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            width: 300,
            height: 50,
            child: ElevatedButton(
              child: Text("Yes"),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection("orders")
                    .doc(id)
                    .update({"status": "preparing"});
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: 300,
            height: 50,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white)),
              child: Text(
                "Not Yet",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  void dispatchConfirm(id) {
    showModalBottomSheet(
      isScrollControlled: false,
      context: context,
      builder: (context) => Wrap(
        direction: Axis.vertical,
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            width: 300,
            margin: EdgeInsets.all(20),
            child: Text(
              "Are you sure This Order is ready to be dispatched.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            width: 300,
            height: 50,
            child: ElevatedButton(
              child: Text("Yes"),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection("orders")
                    .doc(id)
                    .update({"status": "dispatched"});
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: 300,
            height: 50,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white)),
              child: Text(
                "Not Yet",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
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
      body: SafeArea(
        minimum: EdgeInsets.all(10),
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Center(child: Text("Orders")),
                  Container(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            pc.jumpToPage(0);
                          },
                          child: Text(
                            "New Orders",
                            style: TextStyle(
                                fontWeight: currentPage == 0
                                    ? FontWeight.w500
                                    : FontWeight.w300),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            pc.jumpToPage(1);
                          },
                          child: Text(
                            "Preparing",
                            style: TextStyle(
                                fontWeight: currentPage == 1
                                    ? FontWeight.w500
                                    : FontWeight.w300),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            pc.jumpToPage(2);
                          },
                          child: Text(
                            "Dispatched",
                            style: TextStyle(
                                fontWeight: currentPage == 2
                                    ? FontWeight.w500
                                    : FontWeight.w300),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Flexible(
                      child: PageView(
                    controller: pc,
                    onPageChanged: (pageNUmber) {
                      this.setState(() {
                        currentPage = pageNUmber;
                      });
                      print(currentPage);
                    },
                    scrollDirection: Axis.horizontal,
                    children: [
                      ListView(
                          children: newOrder
                              .where(
                                  (element) => element["status"] == "new_Order")
                              .map(
                                (e) => ListTile(
                                  onTap: () {
                                    showOrderDetail(context, e);
                                  },
                                  leading: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        e["ordersTotal"][0]["imageUrl"]),
                                  ),
                                  subtitle: Text("items : " +
                                      e["ordersTotal"].length.toString()),
                                  trailing: TextButton(
                                    child: Text("Make"),
                                    onPressed: () {
                                      prepareConfirm(e["id"]);
                                    },
                                  ),
                                  title: Text(e["ordered_by"]),
                                ),
                              )
                              .toList()),
                      ListView(
                        children: newOrder
                            .where(
                                (element) => element["status"] == "preparing")
                            .map(
                              (e) => ListTile(
                                onTap: () {
                                  showOrderDetail(context, e);
                                },
                                leading: CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                      e["ordersTotal"][0]["imageUrl"]),
                                ),
                                subtitle: Text("Size : " +
                                    e["ordersTotal"].length.toString()),
                                trailing: TextButton(
                                  child: Text("Dispatch"),
                                  onPressed: () async {
                                    dispatchConfirm(e["id"]);
                                  },
                                ),
                                title: Text(e["totalPayment"].toString()),
                              ),
                            )
                            .toList(),
                      ),
                      ListView(
                          children: newOrder
                              .where((element) =>
                                  element["status"] == "dispatched")
                              .map(
                                (e) => ListTile(
                                  onTap: () {
                                    showOrderDetail(context, e);
                                  },
                                  leading: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        e["ordersTotal"][0]["imageUrl"]),
                                  ),
                                  subtitle: Text("Size : " +
                                      e["ordersTotal"].length.toString()),
                                  title: Text(e["totalPayment"].toString()),
                                ),
                              )
                              .toList()),
                    ],
                  ))
                ],
              ),
      ),
    );
  }
}
