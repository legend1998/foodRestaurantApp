import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:smartrestaurant/services/fun.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _selectedIndexForBottomNavigationBar = 0;
  void _onItemTappedForBottomNavigationBar(index) {
    if (index != 0) onItemTappedForBottomNavigationBar(index, this.context);
  }

  PageController pc = PageController();
  int currentPage = 0;
  List newOrder = [
    {"name": "Sambhar"},
    {"name": "idli"},
    {"name": "vada"},
    {"name": "dosa"}
  ];
  List preaparing = [];
  List dispatched = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 20,
        unselectedFontSize: 10,
        selectedFontSize: 12,

        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          _onItemTappedForBottomNavigationBar(value);
        }, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
              icon: new Icon(Icons.fireplace), label: "Orders"),
          BottomNavigationBarItem(
              icon: new Icon(Icons.food_bank), label: "Items"),
          BottomNavigationBarItem(
              icon: new Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: _selectedIndexForBottomNavigationBar,
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(10),
        child: Column(
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
                        .map(
                          (e) => ListTile(
                            trailing: TextButton(
                              child: Text("Make"),
                              onPressed: () {
                                newOrder.remove(e);
                                e["status"] = "preparing";
                                preaparing.add(e);
                                this.setState(() {
                                  newOrder = newOrder;
                                });
                              },
                            ),
                            title: Text(e["name"]),
                          ),
                        )
                        .toList()),
                ListView(
                  children: preaparing
                      .map(
                        (e) => ListTile(
                          trailing: TextButton(
                            child: Text("Dispatch"),
                            onPressed: () {
                              preaparing.remove(e);
                              e["status"] = "dispatched";
                              dispatched.add(e);
                              this.setState(() {
                                preaparing = preaparing;
                              });
                            },
                          ),
                          title: Text(e["name"]),
                        ),
                      )
                      .toList(),
                ),
                ListView(
                    children: dispatched
                        .map(
                          (e) => ListTile(
                            title: Text(e["name"]),
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
