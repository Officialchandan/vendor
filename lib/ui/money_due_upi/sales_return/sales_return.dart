import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  SalesReturnBloc saleReturnBloc = SalesReturnBloc();
  List<BillingDetails> billingDetails = [];
  List<BillingDetails> searchList = [];
  String startDate = "";
  String endDate = "";

  @override
  void initState() {
    super.initState();
    getSalesReturnData(startDate, endDate);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => saleReturnBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "return_ledger_key".tr(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          actions: [
            GestureDetector(
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

                            getSalesReturnData(startDate, endDate);
                          });
                    });
              },
              child: Row(children: [
                Icon(
                  Icons.filter_alt,
                  color: Colors.white,
                ),
                Center(child: Text("${"filter_key".tr()}   ")),
              ]),
            ),
          ],
        ),
        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          enablePullUp: false,
          onRefresh: () {
            getSalesReturnData(startDate, endDate);
          },
          child: Container(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 14, right: 14, top: 14),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      filled: true,

                    // fillColor: Colors.black,
                    hintText: "search_here_key".tr(),
                    hintStyle: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: Colors.black),
                    contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
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
                  onChanged: (value) {
                    saleReturnBloc.add(GetSalesReturnDataSearchEvent(keyWord: value));
                  },
                ),
                SizedBox(
                  height: 10,
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
                          child: Image.asset("assets/images/no_data.gif"),
                        );
                      }
                      if (state is SalesReturnDataSearchState) {
                        if (state.keyWord.isEmpty) {
                          searchList = billingDetails;
                        } else {
                          List<BillingDetails> list = [];
                          billingDetails.forEach((element) {
                            if (element.mobile.toLowerCase().contains(state.keyWord.toLowerCase())) {
                              list.add(element);
                            }
                          });
                          if (list.isEmpty) {
                            return Center(
                              child: Image.asset("assets/images/no_data.gif"),
                            );
                          } else {
                            searchList = list;
                            return ListView.builder(
                                padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                                itemCount: searchList.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    child: BillingDetailsWidget(details: billingDetails[index]),
                                  );
                                });
                          }
                        }
                      }
                      return ListView.builder(
                          itemCount: billingDetails.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.only(left: 14, right: 14),
                              child: BillingDetailsWidget(details: billingDetails[index]),
                            );
                          });
                    }),
                  ),
                ),
              ],
            ),
          ),
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
    _refreshController.refreshCompleted();
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

  String payAmt = "0";
  String colorStatus = "";
  @override
  void initState() {
    this.billingDetails = widget.details;
    if (double.parse(billingDetails!.amountPaidToMyProfit.isEmpty
            ? "0"
            : billingDetails!.amountPaidToMyProfit.isEmpty
                ? "0"
                : billingDetails!.amountPaidToMyProfit) >
        double.parse(billingDetails!.amountPaidToVendor.isEmpty ? "0" : billingDetails!.amountPaidToVendor)) {
      colorStatus = "1";
      // red
      payAmt = (double.parse(billingDetails!.amountPaidToMyProfit.isEmpty
                  ? "0"
                  : billingDetails!.amountPaidToMyProfit.isEmpty
                      ? "0"
                      : billingDetails!.amountPaidToMyProfit) -
              double.parse(billingDetails!.amountPaidToVendor.isEmpty ? "0" : billingDetails!.amountPaidToVendor))
          .toStringAsFixed(2);
    }
    if (double.parse(billingDetails!.amountPaidToMyProfit.isEmpty ? "0" : billingDetails!.amountPaidToMyProfit) <
        double.parse(billingDetails!.amountPaidToVendor.isEmpty ? "0" : billingDetails!.amountPaidToVendor)) {
      colorStatus = "0";
      // green
      payAmt = (double.parse(billingDetails!.amountPaidToVendor.isEmpty ? "0" : billingDetails!.amountPaidToVendor) -
              double.parse(billingDetails!.amountPaidToMyProfit.isEmpty ? "0" : billingDetails!.amountPaidToMyProfit))
          .toStringAsFixed(2);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SalesReturnDetails(
                      billingDetails: billingDetails!,
                    )));
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 10, top: 10),
          // height: billingDetails!.billingType == 1 ? 102 : 82,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                offset: Offset(0.0, 0.0), //(x,y)
                blurRadius:7.0,
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 40, top: 10, bottom: 10, right: 10),
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${billingDetails!.mobile}",
                          style: TextStyle(
                              color: TextBlackLight,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${DateFormat("dd MMM yyyy").format(DateTime.parse(billingDetails!.dateTime))}",
                          style: GoogleFonts.openSans(
                              color: TextGrey,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Text(
                      "\u20B9$payAmt",
                      style: GoogleFonts.openSans(
                          color: colorStatus == "0" ? ApproveTextColor : RejectedTextColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              billingDetails!.billingType == 1 ?
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  height: 80,
                  width: 28,
                  decoration: BoxDecoration(
                    color: ColorPrimary,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8)
                    ),
                  ),
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Center(
                      child: Text(
                        "direct_billing_key".tr(),
                        style: GoogleFonts.openSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ): Container()
            ],
          )),
    );
  }
}
