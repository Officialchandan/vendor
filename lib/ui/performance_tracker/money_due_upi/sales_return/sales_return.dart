import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SalesReturnHistory extends StatefulWidget {
  const SalesReturnHistory({Key? key}) : super(key: key);

  @override
  _SalesReturnHistoryState createState() => _SalesReturnHistoryState();
}

class _SalesReturnHistoryState extends State<SalesReturnHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sales Return",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          Icon(
            Icons.filter_alt,
            color: Colors.white,
          ),
          Center(child: Text("Filter   ")),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 15),
                      height: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(color: Colors.white38),
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1.0, spreadRadius: 1)]),
                      child: ListTile(
                        isThreeLine: true,
                        leading:Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color:Colors.red,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Image.asset(
                            "assets/images/wallpaperflare.com_wallpaper.jpg",
                          ),
                        ),
                        title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(
                            "Geroge Walker",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Container(
                            height: 20,
                            decoration:
                                BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.orange.shade50),
                            child: Text(
                              "  Pay: \u20B966.67   ",
                              style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ]),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(
                              " +91 7560123694",
                              style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                            Container(
                              height: 20,
                              decoration:
                                  BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.orange.shade50),
                              child: Text(
                                "  Pending  ",
                                style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
