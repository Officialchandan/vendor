import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendor/ui/performance_tracker/my_customers/customer_detail_screen.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/widget/calendar_bottom_sheet.dart';

class MyCustomerScreen extends StatefulWidget {
  const MyCustomerScreen({Key? key}) : super(key: key);

  @override
  _MyCustomerScreenState createState() => _MyCustomerScreenState();
}

class _MyCustomerScreenState extends State<MyCustomerScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController txtSearch = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("My Customers"),
        actions: [
          InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return CalendarBottomSheet(onSelect: (startDate, endDate) {
                      print("startDate->$startDate");
                      print("endDate->$endDate");
                    });
                  });
            },
            splashColor: Colors.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(Icons.filter_alt_sharp), Text("Filter")],
            ),
          ),
          const SizedBox(
            width: 15,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                  prefixIconConstraints: BoxConstraints(maxHeight: 50, maxWidth: 50),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide.none),
                  hintText: "Search Customer",
                  hintStyle: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 15,
                );
              },
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(context, PageTransition(child: CustomerDetailScreen(), type: PageTransitionType.fade));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey.shade200, width: 1)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                              "Customer name",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                            )),
                            Text(
                              "7 oct 2021 - 04:50 PM",
                              style: TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                              "+91 1231231231",
                              style: TextStyle(color: Colors.black, fontSize: 14),
                            )),
                            Text(
                              "Qty : 5",
                              style: TextStyle(color: ColorPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: 10,
            ))
          ],
        ),
      ),
    );
  }
}
