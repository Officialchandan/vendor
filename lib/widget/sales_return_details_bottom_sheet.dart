import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:vendor/utility/color.dart';

class SalesReturnDetailsSheet extends StatefulWidget {
  SalesReturnDetailsSheet({Key? key}) : super(key: key);

  @override
  State<SalesReturnDetailsSheet> createState() =>
      _SalesReturnDetailsSheetState();
}

class _SalesReturnDetailsSheetState extends State<SalesReturnDetailsSheet> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Redeem History",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 18,
            ),
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.42,
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                    left: 10,
                  ),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return TimelineTile(
                      alignment: TimelineAlign.start,
                      lineXY: 0.1,
                      isFirst: index == 0 ? true : false,
                      isLast: index == 5 - 1 ? true : false,
                      indicatorStyle: const IndicatorStyle(
                        width: 14,
                        color: Colors.red,
                        padding: EdgeInsets.all(0),
                      ),
                      beforeLineStyle:
                          const LineStyle(color: Colors.red, thickness: 3),
                      endChild: Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 14, top: 8, bottom: 14),
                        child: Stack(
                          children: [
                            Container(
                              height: 70,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 6,
                                      color: Colors.black12,
                                      spreadRadius: 2)
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 14),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "General Store",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87),
                                    ),
                                    Text(
                                      "10 Jan 2022 10:10 am",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: Container(
                                height: 70,
                                width: MediaQuery.of(context).size.width * 0.18,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 6,
                                        color: Colors.black12,
                                        spreadRadius: 2)
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/point.png",
                                      width: 18,
                                      height: 18,
                                    ),
                                    Text(
                                      " 20",
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  shrinkWrap: true,
                ),
              ),
            ),
            SizedBox(
              height: 18,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Text("Close",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
