import 'package:flutter/material.dart';

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
        title: Text("hiiiii"),
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
                      showWeekSheet(context);
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
                  GestureDetector(
                    onTap: () {
                      showWeekDaysSheet(context);
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
          ],
        ),
      ),
    );
  }

  showWeekSheet(context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        )),
        builder: (BuildContext context) {
          return Container(
              padding: EdgeInsets.only(top: 10),
              height: 250,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "   Select Week",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ),
                Container(
                  height: 200,
                  child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Container(height: 40, child: Center(child: Text("Week $index")));
                      }),
                ),
              ])
              // Column(children: [
              //
              //
              // ])
              );
        });
  }

  showWeekDaysSheet(context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        )),
        builder: (BuildContext context) {
          return Container(
              padding: EdgeInsets.only(top: 10),
              height: 250,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: ListView.builder(
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return Container(height: 40, child: Center(child: Text("Week $index")));
                  })
              // Column(children: [
              //
              //
              // ])
              );
        });
  }
}
