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
            "sales_return_key".tr(),
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
                    hintText: "search_here_key".tr(),
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
                  onChanged: (value) {
                    saleReturnBloc.add(GetSalesReturnDataSearchEvent(keyWord: value));
                  },
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
                        child: Image.asset("assets/images/no_data.gif"),
                      );
                    }
                    if (state is SalesReturnDataSearchState) {
                      if (state.keyWord.isEmpty) {
                        searchList = billingDetails;
                      } else {
                        List<BillingDetails> list = [];
                        billingDetails.forEach((element) {
                          if (element.vendorName.toLowerCase().contains(state.keyWord.toLowerCase())) {
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
                        padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                        itemCount: billingDetails.length,
                        itemBuilder: (context, index) {
                          return Container(
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
          margin: EdgeInsets.only(bottom: 20),
          height: billingDetails!.billingType == 1 ? 102 : 82,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1)]),
          child: Column(
            children: [
              billingDetails!.billingType == 1
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 20,
                          width: 70,
                          decoration: BoxDecoration(
                            color: ColorPrimary,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "direct_billing_key".tr(),
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Text(
                          " ${"cancelled_key".tr()}   ",
                          style: TextStyle(
                              color: RejectedTextColor,
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  : SizedBox(),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                          imageUrl: billingDetails!.vendorImage,
                          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                child: CircularProgressIndicator(value: downloadProgress.progress),
                              ),
                          errorWidget: (context, url, error) => Image.asset(
                                "assets/images/placeholder.webp",
                                fit: BoxFit.cover,
                                width: 55,
                                height: 55,
                              ),
                          width: 55,
                          height: 55,
                          fit: BoxFit.cover),
                    ),
                    SizedBox(
                      width: 14,
                    ),
                    Flexible(
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.70,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${billingDetails!.vendorName}",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ]),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text(
                                  "${billingDetails!.mobile}",
                                  style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: colorStatus == "0" ? ApproveTextBgColor : RejectedTextBgColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 2, bottom: 2),
                                    child: Text(
                                      "  ${"pay_key".tr()}: \u20B9 $payAmt  ",
                                      style: TextStyle(
                                          color: colorStatus == "0" ? ApproveTextColor : RejectedTextColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              ]),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
