import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendor/ui/inventory/inventory_screen.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/routs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> name = ["Billing", "Inventory", "Staff Management", "Online Shop", "Performance Tracker", "Account Management"];
  List<String> description = [
    "Billing description",
    "Inventory description",
    "Staff Management description",
    "Online Shop description",
    "Performance Tracker description",
    "Account Management description"
  ];

  List<String> images = [
    "assets/images/home1.png",
    "assets/images/home2.png",
    "assets/images/home4.png",
    "assets/images/home3.png",
    "assets/images/home5.png",
    "assets/images/home6.png"
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.height;
    //print(size);
    //final double itemHeight = size * 0.20;
    // MediaQueryData queryData;
    // queryData = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: Text(""),
        centerTitle: true,
        // backgroundColor: Colors.indigoAccent,
        actions: [
          Padding(
            padding: EdgeInsets.only(
              top: 15,
              bottom: 15,
              right: 15,
            ),
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Row(
                children: [
                  Icon(
                    Icons.share,
                    color: ColorPrimary,
                    size: 12,
                  ),
                  Text(
                    " Share Store  ",
                    style: TextStyle(color: ColorPrimary, fontWeight: FontWeight.w600, fontSize: 12),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      body: StaggeredGridView.countBuilder(
        padding: EdgeInsets.fromLTRB(20, 25, 20, 0),
        crossAxisCount: 2,
        itemCount: 6,
        itemBuilder: (BuildContext context, int index) => new Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: index == 0
                ? Color(0xff6657f4)
                : index == 1
                    ? Color(0xffee776d)
                    : index == 2
                        ? Color(0xfff6ac56)
                        : index == 3
                            ? Color(0xff5086ed)
                            : index == 4
                                ? Color(0xff3ebc91)
                                : index == 5
                                    ? Color(0xffc59280)
                                    : Colors.brown,
            //index.isEven ? Colors.indigoAccent : Colors.indigoAccent[100],
          ),
          child: InkWell(
            onTap: () {
              log("f");
              routeManager(index);
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      padding: EdgeInsets.only(left: 10, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name[index],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                height: 1.2,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(
                            description[index],
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )),
                  Container(
                      child: Image.asset(
                    images[index],
                    //height: 70,
                    width: 70,
                  ))
                ],
              ),
            ),
          ),
        ),
        staggeredTileBuilder: (int index) => StaggeredTile.count(
          1 // it specifies the number of columns,
          ,
          index == 0
              ? size / 540
              : index == 1
                  ? size / 640
                  : index == 2
                      ? size / 540
                      : index == 3
                          ? size / 640
                          : index == 4
                              ? size / 580
                              : index == 5
                                  ? size / 580
                                  : 0.0,
        ),
        mainAxisSpacing: 25.0,
        crossAxisSpacing: 15.0,
      ),
    );
  }

  routeManager(index) {
    log("$index");
    index == 0
        ? Navigator.pushNamed(
            context,
            Routes.BillingScreen,
          )
        : index == 1
            ? Navigator.push(
                context,
                PageTransition(
                  child: InventoryScreen(),
                  type: PageTransitionType.fade,
                ))
            : index == 2
                ? Navigator.pop(context)
                : index == 3
                    ? Navigator.pop(context)
                    : index == 4
                        ? Navigator.pop(context)
                        : index == 5
                            ? Navigator.pop(context)
                            : Navigator.pop(context);
  }
}
