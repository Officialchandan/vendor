import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widget/calendar_bottom_sheet.dart';

class UpiTransferHistory extends StatefulWidget {
  const UpiTransferHistory({Key? key}) : super(key: key);

  @override
  _UpiTransferHistoryState createState() => _UpiTransferHistoryState();
}

class _UpiTransferHistoryState extends State<UpiTransferHistory> {
  String startDate = "";
  String endDate = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "UPI Transfer",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return CalendarBottomSheet(onSelect: (startDate, endDate) {
                      this.startDate = startDate;
                      this.endDate = endDate;
                      print("startDate->$startDate");
                      print("endDate->$endDate");
                      // getCustomer();
                    });
                  });
              print("startDate--->$startDate");
              print("endDate--->$endDate");
            },
            child: Row(children: [
              Icon(
                Icons.filter_alt,
                color: Colors.white,
              ),
              Center(child: Text("Filter   ")),
            ]),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15, top: 15),
              child: TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  filled: true,

                  // fillColor: Colors.black,
                  hintText: "Search Here...",
                  hintStyle: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: Colors.black),
                  contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  itemCount: 20,
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
                          Padding(
                            padding: EdgeInsets.only(left: 12.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "20 Feb 2022 - 5.30 PM",
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Container(
                                    height: 20,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20), color: Colors.orange.shade50),
                                    child: Text(
                                      "  Pending  ",
                                      style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ]),
                          ),
                          Container(
                            width: 90,
                          ),
                        ]),
                      ),
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
}
