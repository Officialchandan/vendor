import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendor/utility/color.dart';

class NormalLedger extends StatefulWidget {
  const NormalLedger({Key? key}) : super(key: key);

  @override
  _NormalLedgerState createState() => _NormalLedgerState();
}

class _NormalLedgerState extends State<NormalLedger> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Master Ledger",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 50,
              color: Colors.grey[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      showPicker();
                    },
                    child: Container(
                      width: 100,
                      height: 35,
                      decoration: BoxDecoration(color: Colors.grey[350], borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Week",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  GestureDetector(
                    onTap: () {
                      showDaysPicker();
                    },
                    child: Container(
                      width: 100,
                      height: 35,
                      decoration: BoxDecoration(color: Colors.grey[350], borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Day",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.arrow_drop_down)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: 20,
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 5),
                  itemBuilder: (context, index) {
                    return Stack(children: [
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        padding: EdgeInsets.all(0),
                        height: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border: Border.all(color: Colors.white38),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1.0, spreadRadius: 1)]),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "    +91 23689745035",
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                                Text("    5.30 PM"),
                              ]),
                          Row(
                            children: [
                              Center(
                                child: Container(
                                  height: 20,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20), color: Colors.orange.shade50),
                                  child: Text(
                                    "  Pending  ",
                                    style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: 90,
                              )
                            ],
                          ),
                        ]),
                      ),
                      Positioned(
                          top: 10,
                          left: 0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(30)),
                            child: Transform.rotate(
                              angle: 12.0,
                              //turns: new AlwaysStoppedAnimation(330 / 360),
                              child: Container(color: Colors.red, child: new Text("Lorem ")),
                            ),
                          )),
                      Positioned(
                        right: 0,
                        top: 15,
                        child: Container(
                          alignment: Alignment.center,
                          width: 90,
                          height: 70,
                          decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius:
                                  BorderRadius.only(bottomRight: Radius.circular(10), topRight: Radius.circular(10))),
                          child: Text(
                            " \u20B9 206.67 ",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
                          ),
                        ),
                      )
                    ]);
                  }),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> days = [
    Text("Mon"),
    Text("Tue"),
    Text("Wed"),
    Text("Thr"),
    Text("Fri"),
    Text("Sat"),
    Text("Sun"),
  ];
  String selectedValue = "";

  List<Widget> Weeks = [
    Text("Week 1"),
    Text("Week 2"),
    Text("Week 3"),
    Text("Week 4"),
    Text("Week 5"),
    Text("Week 6"),
  ];
  String weekselectedValue = "";

  void showPicker() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        )),
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.40,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "   Select Week",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                      height: MediaQuery.of(context).copyWith().size.height * 0.30,
                      color: Colors.white,
                      child: CupertinoPicker(
                        children: Weeks,
                        onSelectedItemChanged: (value) {
                          log("$value");
                          // Text text = countries[value];
                          // selectedValue = text.data.toString();
                          setState(() {});
                        },
                        itemExtent: 25,
                        diameterRatio: 1,
                        useMagnifier: true,
                        scrollController: FixedExtentScrollController(initialItem: 1),
                        magnification: 1.3,
                        looping: true,
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 30,
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 30,
                          child: Text(
                            "Done",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorPrimary),
                          ),
                        ),
                      )
                    ],
                  )
                ]),
          );
        });
  }

  void showDaysPicker() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        )),
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.40,
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                "Select Days",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                  height: MediaQuery.of(context).copyWith().size.height * 0.30,
                  color: Colors.white,
                  child: CupertinoPicker(
                    children: days,
                    onSelectedItemChanged: (value) {
                      log("$value");
                      // Text text = countries[value];
                      // selectedValue = text.data.toString();
                      setState(() {});
                    },
                    itemExtent: 25,
                    diameterRatio: 1,
                    useMagnifier: true,
                    scrollController: FixedExtentScrollController(initialItem: 1),
                    magnification: 1.3,
                    looping: true,
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 30,
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 30,
                      child: Text(
                        "Done",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorPrimary),
                      ),
                    ),
                  )
                ],
              )
            ]),
          );
        });
  }
}
