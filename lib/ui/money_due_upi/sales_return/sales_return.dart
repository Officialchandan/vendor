import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor/ui/inventory/sale_return/bloc/sale_return_bloc.dart';
import 'package:vendor/ui/money_due_upi/sales_return/response/upi_sales_return_response.dart';
import 'package:vendor/ui/money_due_upi/sales_return/sales_return_bloc/sales_return_bloc.dart';
import 'package:vendor/ui/money_due_upi/sales_return/sales_return_bloc/sales_return_events.dart';
import 'package:vendor/ui/money_due_upi/sales_return/sales_return_bloc/sales_return_states.dart';
import 'package:vendor/ui/money_due_upi/sales_return/sales_return_details/sales_return_details.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/sharedpref.dart';

import '../../../widget/calendar_bottom_sheet.dart';

class SalesReturnHistory extends StatefulWidget {
  const SalesReturnHistory({Key? key}) : super(key: key);

  @override
  _SalesReturnHistoryState createState() => _SalesReturnHistoryState();
}

class _SalesReturnHistoryState extends State<SalesReturnHistory> {
  SalesReturnBloc saleReturnBloc = SalesReturnBloc();
  List<BillingDetails> billingDetails = [];
  String startDate = "";
  String endDate = "";

  @override
  void initState() {
    super.initState();
    getSalesReturnData("", "");
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => saleReturnBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Sales Return",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return CalendarBottomSheet(
                          onSelect: (startDate, endDate) {
                        this.startDate = startDate;
                        this.endDate = endDate;

                        getSalesReturnData(startDate, endDate);
                      });
                    });
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
        body: Column(
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
                  hintStyle: GoogleFonts.openSans(
                      fontWeight: FontWeight.w600, color: Colors.black),
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
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
              child: BlocBuilder<SalesReturnBloc, SalesReturnStates>(
                builder: ((context, state) {
                  if (state is SalesReturnHistoryState) {
                    billingDetails = state.response;
                  }
                  if (state is SalesReturnLoadingState) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is SalesReturnFailureState) {
                    return Center(
                      child: Text(state.message),
                    );
                  }
                  return ListView.builder(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                      itemCount: billingDetails.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: BillingDetailsWidget(
                              details: billingDetails[index]),
                        );
                      });
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getSalesReturnData(String startDate, String endDate) async {
    var vendorId = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
    Map<String, dynamic> input = HashMap();
    input['vendor_id'] = vendorId;
    input["from_date"] = startDate;
    input["to_date"] = endDate;
    saleReturnBloc.add(GetSalesReturnHistoryEvent(input: input));
  }
}

class BillingDetailsWidget extends StatefulWidget {
  final BillingDetails details;
  BillingDetailsWidget({required this.details, Key? key}) : super(key: key);

  @override
  State<BillingDetailsWidget> createState() => _BillingDetailsWidgetState();
}

class _BillingDetailsWidgetState extends State<BillingDetailsWidget> {
  BillingDetails? billingDetails;

  String payAmt = "";
  String colorStatus = "";
  @override
  void initState() {
    this.billingDetails = widget.details;
    if (double.parse(billingDetails!.amountPaidToMyProfit) >
        double.parse(billingDetails!.amountPaidToVendor)) {
      colorStatus = "1";
      // red
      payAmt = (double.parse(billingDetails!.amountPaidToMyProfit) -
              double.parse(billingDetails!.amountPaidToVendor))
          .toStringAsFixed(2);
    }
    if (double.parse(billingDetails!.amountPaidToMyProfit) <
        double.parse(billingDetails!.amountPaidToVendor)) {
      colorStatus = "0";
      // green
      payAmt = (double.parse(billingDetails!.amountPaidToVendor) -
              double.parse(billingDetails!.amountPaidToMyProfit))
          .toStringAsFixed(2);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      height: 70,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: Colors.white38),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 1.0, spreadRadius: 1)
          ]),
      child: ListTile(
        selectedTileColor: Colors.transparent,
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SalesReturnDetails()));
        },
        isThreeLine: true,
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Image.asset(
            "assets/images/wallpaperflare.com_wallpaper.jpg",
          ),
        ),
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            "Geroge Walker",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color:
                  colorStatus == "0" ? ApproveTextBgColor : RejectedTextBgColor,
            ),
            child: Text(
              "  Pay: \u20B9 $payAmt ",
              style: TextStyle(
                  color:
                      colorStatus == "0" ? ApproveTextColor : RejectedTextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
          )
        ]),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              " +91 7560123694",
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
            Container(
              // height: 20,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: DirectBillTextBgColor),
              child: Text(
                "  Direct Billing  ",
                style: TextStyle(
                    color: DirectBillingTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
