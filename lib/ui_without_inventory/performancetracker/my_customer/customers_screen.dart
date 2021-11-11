import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/get_my_customer_response.dart';
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
        title: Text("My Customers"),
        actions: [
          InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return CalendarBottomSheet(onSelect: (startDate, endDate) {
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
              controller: txtSearch,
              keyboardType: TextInputType.number,
              onChanged: (text) {
                if (text.isNotEmpty) {
                  List<Customer> searchList = [];

                  customerList.forEach((element) {
                    if (element.customerName.toLowerCase().contains(text.trim().toLowerCase())) {
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
                  hintText: "Search Customer",
                  hintStyle: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: 20,
            ),
            // MaterialButton(
            //   onPressed: () {
            //     equation = txtSearch.text.trim();
            //     expression = equation;
            //
            //
            //     String str1 = expression;
            //
            //
            //     List<String> charList = [];
            //     String ma = "";
            //     for (int i = 0; i < str1.length; i++) {
            //       if (str1[i] == "+" ||
            //           str1[i] == "-" ||
            //           str1[i] == "×" ||
            //           str1[i] == "÷" ||
            //           str1[i] == "/" ||
            //           str1[i] == "*" ||
            //           str1[i] == "%") {
            //         if (ma.isNotEmpty) {
            //           charList.add(ma);
            //         }
            //         charList.add(str1[i]);
            //         ma = "";
            //       } else {
            //         ma = ma + str1[i];
            //         if (i == str1.length - 1) {
            //           if (ma.isNotEmpty) {
            //             charList.add(ma);
            //           }
            //         }
            //       }
            //     }
            //
            //     int l = charList.where((element) => element == "%").toList().length;
            //
            //     for (int i = 0; i < l; i++) {
            //       print("charList-->$charList");
            //       int i = charList.indexWhere((element) => element == "%");
            //       int a = i - 1;
            //       int b = i + 1;
            //       double aa = double.parse(charList[a]);
            //       double bb = double.parse(charList[b]);
            //       double cc = (aa * bb) / 100;
            //       print("cc-->$cc");
            //       charList[a] = cc.toString();
            //       print("charList1-->$charList");
            //       charList.removeAt(b);
            //       print("charList1-->$charList");
            //       charList.removeAt(i);
            //       print("charList1-->$charList");
            //     }
            //
            //     String exp = "";
            //     charList.forEach((element) {
            //       exp += element;
            //     });
            //
            //     print("exp-->$exp");
            //     expression = exp;
            //
            //     // str[0].replaceAll("+", "_").replaceAll("-", "_").replaceAll("×", "_").replaceAll("÷", "_");
            //     // List<String> strList1 = str[0].split("_");
            //     // String str2 = strList1.last;
            //     //
            //     // String str3 = str[1];
            //     // str[1].replaceAll("+", "_").replaceAll("-", "_").replaceAll("×", "_").replaceAll("÷", "_");
            //     // List<String> strList2 = str[1].split("_");
            //     // String str4 = strList1.first;
            //     //
            //     // strList2.removeAt(0);
            //     // strList1.removeLast();
            //
            //     expression = expression.replaceAll('×', '*');
            //     expression = expression.replaceAll('÷', '/');
            //     print(expression);
            //
            //     //12*311*54/45%45 = 9952
            //     //42*78/45%48=151.66
            //     // 8*5-9/4*6+8%4+8 = 34.82
            //     // 40-2.25*6+0.32+8
            //     //40-13.5+0.35+8
            //
            //     try {
            //       Parser p = Parser();
            //       Expression exp = p.parse(expression);
            //
            //       ContextModel cm = ContextModel();
            //       result = '${exp.evaluate(EvaluationType.REAL, cm)}';
            //       print(result);
            //     } catch (e) {
            //       result = "";
            //     }
            //   },
            //   child: Text("calculate"),
            // ),
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
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 15,
                      );
                    },
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    itemBuilder: (context, index) {
                      Customer customer = snapshot.data![index];

                      return Container(
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
                                  customer.customerName,
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                                )),
                                Text(
                                  Utility.getFormatDate1(customer.date),
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
                                  "+91 ${customer.mobile}",
                                  style: TextStyle(color: Colors.black, fontSize: 14),
                                )),
                                Text(
                                  "Amount spend : ${customer.amountSpend}",
                                  style: TextStyle(color: ColorPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                    itemCount: snapshot.data!.length,
                  );
                }
                return Center(
                  child: Text("Customer not found!"),
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

      GetMyCustomerResponse response = await apiProvider.getChatPapdiCustomer(input);

      if (response.success) {
        customerList = response.data!;
        streamController.add(response.data!);
      }
    } else {
      Utility.showToast(Constant.INTERNET_ALERT_MSG);
    }
  }
}
