import 'dart:async';
import 'dart:collection';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/get_my_customer_response.dart';
import 'package:vendor/ui/performance_tracker/my_customers/customer_detail_screen.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/utility/utility.dart';
import 'package:vendor/widget/calendar_bottom_sheet.dart';

class MyCustomerScreen extends StatefulWidget {
  const MyCustomerScreen({Key? key}) : super(key: key);

  @override
  _MyCustomerScreenState createState() => _MyCustomerScreenState();
}

class _MyCustomerScreenState extends State<MyCustomerScreen> {
  TextEditingController txtSearch = TextEditingController();
  List<Customer> customerList = [];
  StreamController<List<Customer>> streamController = StreamController();
  String startDate = "";
  String endDate = "";

  @override
  void initState() {
    getCustomer();
    super.initState();
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("my_customers_key".tr()),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        actions: [
          InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return CalendarBottomSheet(
                        endDate: endDate,
                        startDate: startDate,
                        onSelect: (startDate, endDate) {
                          this.startDate = startDate;
                          this.endDate = endDate;
                          print("startDate->$startDate");
                          print("endDate->$endDate");
                          getCustomer();
                        });
                  });
            },
            splashColor: Colors.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(Icons.filter_alt_sharp), Text("filter_key".tr())],
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
              onChanged: (text) {
                if (text.isNotEmpty) {
                  List<Customer> searchList = [];

                  customerList.forEach((element) {
                    if (element.customerName.toLowerCase().contains(text.trim().toLowerCase())) {
                      searchList.add(element);
                    }

                    if (element.mobile.toLowerCase().contains(text.trim().toLowerCase())) {
                      searchList.add(element);
                    }
                  });

                  streamController.add(searchList);
                } else {
                  streamController.add(customerList);
                }
              },
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
                  hintText: "search_customer_key".tr(),
                  hintStyle: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: StreamBuilder<List<Customer>>(
              stream: streamController.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }

                if (snapshot.hasData) {
                  return ListView.separated(
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 15,
                      );
                    },
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    itemBuilder: (context, index) {
                      Customer customer = snapshot.data![index];

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: CustomerDetailScreen(customer: customer), type: PageTransitionType.fade));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey.shade200, width: 1)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                    customer.customerName,
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                                  )),
                                  Text(
                                    Utility.getFormatDate1(customer.date),
                                    style: TextStyle(color: Colors.black, fontSize: 11),
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
                                    "+91 ${customer.mobile}",
                                    style: TextStyle(color: Colors.black, fontSize: 14),
                                  )),
                                  // Text(
                                  //   "qty_key".tr() + " : ${customer.qty}",
                                  //   style: TextStyle(
                                  //       color: ColorPrimary,
                                  //       fontWeight: FontWeight.bold,
                                  //       fontSize: 14),
                                  // ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: snapshot.data!.length,
                  );
                }
                return Center(
                  child: Text("customer_not_found_key".tr()),
                );
              },
            ))
          ],
        ),
      ),
    );
  }

  void getCustomer() async {
    if (await Network.isConnected()) {
      Map<String, dynamic> input = HashMap<String, dynamic>();

      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
      input["from_date"] = startDate;
      input["to_date"] = endDate;

      GetMyCustomerResponse response = await apiProvider.getMyCustomer(input);

      if (response.success) {
        customerList = response.data!;
        streamController.add(response.data!);
      } else {
        customerList = [];
        streamController.addError("${response.message}");
      }
    } else {
      Utility.showToast(msg: Constant.INTERNET_ALERT_MSG);
    }
  }
}
