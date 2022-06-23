import 'dart:async';
import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/chat_papdi_module/get_customer_of_chatpapdi.dart';
import 'package:vendor/ui_without_inventory/performancetracker/my_customer/customer_detail_screen.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/utility/utility.dart';
import 'package:vendor/widget/calendar_bottom_sheet.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key? key}) : super(key: key);

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  TextEditingController txtSearch = TextEditingController();
  List<Customer> customerList = [];
  StreamController<List<Customer>> streamController = StreamController();
  String startDate = "";
  String endDate = "";
  String equation = "0";
  String result = "0";
  String expression = "";

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
        title: Text(
          "my_customers_key".tr(),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: TextFormField(
                controller: txtSearch,
                keyboardType: TextInputType.number,
                onChanged: (text) {
                  if (text.isNotEmpty) {
                    List<Customer> searchList = [];

                    customerList.forEach((element) {
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
                  filled: true,
                  hintText: "search_customer_key".tr(),
                  hintStyle: TextStyle(fontWeight: FontWeight.bold),
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: textFieldBorderColor, width: 1.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: textFieldBorderColor, width: 1.0),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: textFieldBorderColor, width: 1.0),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
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

                if (snapshot.hasData) {
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 15,
                      );
                    },
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    itemBuilder: (context, index) {
                      Customer customer = snapshot.data![index];

                      return Container(
                        height: 70,
                        margin: EdgeInsets.only(left: 10, right: 10),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              offset: Offset(0.0, 0.0), //(x,y)
                              blurRadius: 7.0,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CustomerDetailScreen(
                                          customer: customer,
                                        )));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                      child: Text(
                                    customer.customerName,
                                    style: GoogleFonts.openSans(
                                        color: TextBlackLight, fontWeight: FontWeight.bold, fontSize: 16),
                                  )),
                                  Text(
                                    DateFormat("dd MMM yyyy").format(customer.date),
                                    style: GoogleFonts.openSans(
                                        color: TextGrey, fontSize: 13, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                    "+91 ${customer.mobile}",
                                    style: GoogleFonts.openSans(
                                        color: TextGrey, fontSize: 13, fontWeight: FontWeight.w600),
                                  )),
                                  // Text(
                                  //   "amount_spend_key".tr() +
                                  //       ": ${customer.amountSpend}",
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
                  child: Text("customer_not_found_key!".tr()),
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
      GetMyChatPapdiCustomerResponse response = await apiProvider.getChatPapdiCustomer(input);

      if (response.success) {
        customerList = response.data!;
        streamController.add(response.data!);
      }
    } else {
      Utility.showToast(msg: Constant.INTERNET_ALERT_MSG);
    }
  }
}
