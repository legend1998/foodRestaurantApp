import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smartrestaurant/HomePageScreen.dart';
import 'package:smartrestaurant/ProfilePage.dart';
import 'package:intl/intl.dart';

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

void showOrderDetail(context, order) {
  var date = DateTime.parse(order["orderTime"]);
  var time = DateFormat('dd/mm – kk:mm').format(date);
  List items = order["ordersTotal"] ?? [];

  showModalBottomSheet(
      context: context,
      builder: (context) => Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10, right: 10),
                        child: Text(
                          "Order Value : Rs " +
                              order["totalPayment"].toString(),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, right: 10),
                        child: Text(
                          '$time',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: ListView(
                  shrinkWrap: true,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(it["quantity"].toString()),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(it["unit"]),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                              ],
                            ),
                          ))
                      .toList(),
                ))
              ],
            ),
          ));
}
