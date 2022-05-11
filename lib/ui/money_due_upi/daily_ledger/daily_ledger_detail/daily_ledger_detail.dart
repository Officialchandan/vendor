import 'dart:collection';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor/ui/money_due_upi/daily_ledger/daily_ledger_detail/daily_ledger_detail_bloc/daily_ledger_detail_bloc.dart';
import 'package:vendor/ui/money_due_upi/daily_ledger/daily_ledger_detail/daily_ledger_detail_bloc/daily_ledger_detail_event.dart';
import 'package:vendor/ui/money_due_upi/daily_ledger/daily_ledger_detail/daily_ledger_detail_bloc/daily_ledger_detail_state.dart';
import 'package:vendor/ui/money_due_upi/sales_return/response/upi_sales_return_response.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/sharedpref.dart';

import '../../normal_ledger/model/normal_ladger_response.dart';

class DailyLedgerDetails extends StatefulWidget {
  // final List<OrderData> commonLedgerHistory;
  final OrderData order;

  // final int index;
  DailyLedgerDetails({Key? key, required this.order}) : super(key: key);

  @override
  State<DailyLedgerDetails> createState() => _DailyLedgerDetailsState();
}

class _DailyLedgerDetailsState extends State<DailyLedgerDetails> {
  // late List<CommonLedgerHistory> commonLedgerHistory;
  List<CommonSaleReturnProductDetails> productDetails = [];
  double reddem = 0, finalamount = 0;
  List<BillingDetails> billingDetails = [];
  BillingDetails? details;
  String amtPaidStatus = "";
  String payAmt = "";
  double amtPaid = 0;
  double redeemCoins = 0;
  double earnCoins = 0;
  double netBalance = 0;
  double amtreturn = 0;
  double orderTotal = 0;
  double totalComission = 0;
  double returnCommision = 0;
  double returnAmountpaid = 0;
  double returnRedemption = 0;
  double returnEarned = 0;
  double returnCollectionAmnt = 0;
  double returnCommisionAmnt = 0;

  DailyLedgerDetailBloc dailyLedgerDetailBloc = DailyLedgerDetailBloc();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // commonLedgerHistory = widget.commonLedgerHistory;
    // index = widget.index;
    log("orderType-->${widget.order.orderType}");
    log("order-->${widget.order.toString()}");
    calculation();
  }

  getDailyLedgerData() async {
    var vendorId = await SharedPref.getIntegerPreference(SharedPref.VENDORID);

    Map<String, dynamic> input = HashMap();
    input['vendor_id'] = vendorId;
    input['order_id'] = widget.order.orderId;
    input["from_date"] = "";
    input["to_date"] = "";
    dailyLedgerDetailBloc.add(GetDailyLedgerDetailHistoryEvent(input: input));
  }

  void calculation() {
    if (widget.order.orderType == 1) {
      reddem = double.parse(widget.order.billingDetails.first.redeemCoins);

      orderTotal = double.parse(widget.order.billingDetails.first.total);
      log("ordertt-->${double.parse(widget.order.billingDetails.first.total)} ");
      log("ordertt-->${(reddem / 3)} ");
      totalComission = double.parse(widget.order.billingDetails.first.commissionValue);
      returnAmountpaid = double.parse(widget.order.billingDetails.first.amountPaid);
      returnRedemption = double.parse(widget.order.billingDetails.first.redeemCoins);
      returnEarned = double.parse(widget.order.billingDetails.first.earningCoins);
      widget.order.isReturn == 1 ? returnCommisionAmnt = totalComission : totalComission;

      // if (double.parse(widget.order.myprofitRevenue) > reddem) {
      //   log("${double.parse(widget.order.myprofitRevenue)}");
      //   finalamount = double.parse(widget.order.myprofitRevenue) - reddem;
      // } else {
      //   finalamount = reddem - double.parse(widget.order.myprofitRevenue);
      // }
    } else {
      // getNormalLedgerData();
      widget.order.orderDetails.forEach((element) {
        reddem += double.parse(element.redeemCoins);
        log("$reddem");
        reddem = reddem / 3;
        orderTotal += double.parse(element.total);
        totalComission += double.parse(element.commissionValue);
        returnAmountpaid += element.isReturn == 1 ? double.parse(element.amountPaid) : 0;
        returnRedemption += element.isReturn == 1 ? double.parse(element.redeemCoins) : 0;
        log("returnRedemption--->$returnRedemption");
        returnEarned = double.parse(element.earningCoins);
        element.isReturn == 1 ? returnCommisionAmnt += totalComission : 0;
        log("orderTotal--->$reddem");
        // if (double.parse(widget.order.myprofitRevenue) > reddem) {
        //   log("${double.parse(widget.order.myprofitRevenue)}");
        //   finalamount = double.parse(widget.order.myprofitRevenue) - reddem;
        // } else {
        //   finalamount = reddem - double.parse(widget.order.myprofitRevenue);
        // }
      });
    }
  }

  void returnSummaryCollection() {
    if (returnRedemption >= returnEarned) {
      returnCollectionAmnt = 0;
      log("returnCollectionAmnt==>$returnCollectionAmnt");
    } else {
      returnCollectionAmnt = returnEarned - returnRedemption;
      log("returnCollectionAmnt1==>$returnCollectionAmnt");
      if (double.parse(details!.customerCoinBalance) >= returnCollectionAmnt) {
        returnCollectionAmnt = 0;
        log("returnCollectionAmnt0==>$returnCollectionAmnt");
      } else {
        log("returnCollectionAmnt2==>$returnCollectionAmnt");
        returnCollectionAmnt = returnCollectionAmnt - double.parse(details!.customerCoinBalance);
        log("returnCollectionAmnt3==>$returnCollectionAmnt");
        returnCollectionAmnt / 3 >= returnAmountpaid
            ? returnAmountpaid - (returnCollectionAmnt / 3)
            : returnCollectionAmnt / 3;
        if (returnCollectionAmnt / 3 <= returnAmountpaid) {
          returnCollectionAmnt = returnCollectionAmnt / 3;
          log("returnCollectionAmnt4==>$returnCollectionAmnt");
        } else {
          returnCollectionAmnt = returnAmountpaid - (returnCollectionAmnt / 3);
          log("returnCollectionAmnt5==>$returnCollectionAmnt");
        }
        //w   returnCollectionAmnt = returnAmountpaid - returnCollectionAmnt;

      }
    }
  }

  void salesreturnCalculations() {
    for (var products in details!.orderDetails) {
      CommonSaleReturnProductDetails dailyBillingProducts = CommonSaleReturnProductDetails(
        orderId: products.orderId,
        mobile: products.mobile,
        productId: products.productId,
        productName: products.productName,
        productImage: products.productImage,
        qty: products.qty,
        price: products.price,
        total: products.total,
        amountPaid: products.amountPaid,
        redeemCoins: products.redeemCoins,
        earningCoins: products.earningCoins,
        myProfitRevenue: products.myProfitRevenue,
        billingId: "",
        categoryId: "",
        categoryImage: "",
        categoryName: "",
        commission: products.commission,
      );
      productDetails.add(dailyBillingProducts);
    }

    // Amount Paid
    productDetails.forEach((element) {
      amtPaid += double.parse(element.amountPaid);
    });

    // Redeem Coin
    productDetails.forEach((element) {
      redeemCoins += double.parse(element.redeemCoins);
    });

    // Earn Coins
    productDetails.forEach((element) {
      earnCoins += double.parse(element.earningCoins);
    });

    // Net Balance
    if (redeemCoins >= earnCoins) {
      netBalance = 0;
    } else if (earnCoins > redeemCoins && earnCoins != 0) {
      netBalance = earnCoins - redeemCoins;
      log("message >>> $netBalance");
      if (double.parse(details!.customerCoinBalance) != 0) {
        if (double.parse(details!.customerCoinBalance) >= netBalance) {
          log("message2 >>> $netBalance");
          netBalance = 0;
        } else {
          log("message3 >>> $netBalance");
          netBalance = netBalance - double.parse(details!.customerCoinBalance);
        }
      } else {
        netBalance = double.parse(details!.returnAmountCustomer) - netBalance / 3;
      }
    } else {
      if (double.parse(details!.customerCoinBalance) != 0) {
        if (double.parse(details!.customerCoinBalance) >= earnCoins) {
          netBalance = 0;
        } else {
          netBalance = earnCoins - double.parse(details!.customerCoinBalance);
        }
      } else {
        netBalance = double.parse(details!.returnAmountCustomer) - earnCoins / 3;
      }
    }

    if (double.parse(details!.amountPaidToVendor) > double.parse(details!.amountPaidToMyProfit)) {
      amtreturn = double.parse(details!.amountPaidToVendor) - double.parse(details!.amountPaidToMyProfit);
    } else {
      amtreturn = double.parse(details!.amountPaidToMyProfit) - double.parse(details!.amountPaidToVendor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DailyLedgerDetailBloc>(
      create: (context) => dailyLedgerDetailBloc,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Text(
            "daily_ledger_details_key".tr(),
            style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: widget.order.isReturn == 1
                ? BlocBuilder<DailyLedgerDetailBloc, DailyLedgerDetailStates>(builder: ((context, state) {
                    if (state is DailyLedgerDetailInitialState) {
                      getDailyLedgerData();
                    }
                    if (state is DailyLedgerDetailHistoryState) {
                      billingDetails = state.response;
                      details = billingDetails.first;

                      salesreturnCalculations();
                      returnSummaryCollection();
                    }
                    if (state is DailyLedgerDetailLoadingState) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is DailyLedgerDetailFailureState) {
                      return Center(
                        child: Image.asset("assets/images/no_data.gif"),
                      );
                    }
                    if (billingDetails.isEmpty) {
                      log("===>$billingDetails");
                      return Center(child: CircularProgressIndicator());
                    }
                    return dataSalesReturn(context);
                  }))
                : dataSalesReturn(context),
          ),
        ),
      ),
    );
  }

  dataSalesReturn(BuildContext contex) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 14, right: 0),
                child: Text(
                  "${widget.order.firstName}",
                  style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold, color: TextBlackLight),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "+91 ${widget.order.mobile}",
                      style: GoogleFonts.openSans(fontSize: 13, fontWeight: FontWeight.w600, color: TextGrey),
                    ),
                    Text(
                      "${DateFormat("yyyy MM dd ").format(widget.order.dateTime)}(${DateFormat.jm().format(widget.order.dateTime)})",
                      style: GoogleFonts.openSans(fontSize: 13, fontWeight: FontWeight.w600, color: TextGrey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 14, top: 10),
                  child: Text(
                    "order_summary_key".tr(),
                    style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold, color: TextBlackLight),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              widget.order.orderType == 1
                  ? DirectBillingListItem(
                      commission: widget.order.billingDetails.first.commissionValue,
                      detail: widget.order.billingDetails.first,
                    )
                  : Container(
                      height: widget.order.orderDetails.length > 1 ? 160 : 80,
                      child: ListView.builder(
                        itemCount: widget.order.orderDetails.length,
                        itemBuilder: ((context, index) {
                          return Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //       color: Colors.black12,
                                    //       spreadRadius: 4,
                                    //       blurRadius: 10)
                                    // ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Container(
                                              color: Colors.white,
                                              child: Image.network(
                                                "${widget.order.orderDetails[index].productImage}",
                                                height: 45,
                                                width: 45,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          child: Flexible(
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "${widget.order.orderDetails[index].productName}",
                                                      style: GoogleFonts.openSans(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                          color: TextBlackLight),
                                                    ),
                                                    Text(
                                                      "\u20B9 ${widget.order.orderDetails[index].total}",
                                                      style: GoogleFonts.openSans(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                          color: TextBlackLight),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "${widget.order.orderDetails[index].qty} x \u20B9 ${widget.order.orderDetails[index].price}",
                                                      style: GoogleFonts.openSans(
                                                          fontSize: 13, fontWeight: FontWeight.w600, color: TextGrey),
                                                    ),
                                                    Text(
                                                      "${"commission_key".tr()} \u20B9${widget.order.orderDetails[index].commissionValue}",
                                                      style: GoogleFonts.openSans(
                                                          fontSize: 13, fontWeight: FontWeight.w600, color: TextGrey),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              double.parse(widget.order.orderDetails[index].redeemCoins) > 0
                                  ? Positioned(
                                      top: 4,
                                      right: 25,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: RejectedTextBgColor,
                                          borderRadius: BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: RejectedTextBgColor,
                                            )
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 5, right: 5, top: 1, bottom: 1),
                                          child: Text(
                                            "Redeemed",
                                            style: GoogleFonts.openSans(
                                                color: RejectedTextColor, fontWeight: FontWeight.bold, fontSize: 10),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              widget.order.orderDetails[index].isReturn == 1
                                  ? Positioned(
                                      left: 8,
                                      bottom: 10,
                                      child: Container(
                                        height: 65,
                                        width: 25,
                                        decoration: BoxDecoration(
                                            color: ColorPrimary,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))),
                                        child: Center(
                                          child: RotatedBox(
                                            quarterTurns: 3,
                                            child: Text(
                                              "return_key".tr(),
                                              style: TextStyle(fontSize: 14, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ))
                                  : Container()
                            ],
                          );
                        }),
                      ),
                    ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "billing_key".tr(),
                    style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold, color: TextBlackLight),
                  ),
                  widget.order.isReturn == 1
                      ? InkWell(
                          onTap: () {
                            invoice();
                          },
                          child: Text(
                            "view_details_key".tr(),
                            style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: TextGrey),
                          ),
                        )
                      : Container(
                          height: 0,
                        ),
                ],
              ),

              SizedBox(
                height: widget.order.isReturn == 0 ? 8 : 0,
              ),
              widget.order.isReturn == 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "totals_order_value_key".tr(),
                          style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w600, color: TextGrey),
                        ),
                        Text(
                          "\u20B9 ${orderTotal.toStringAsFixed(2)}",
                          style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                        ),
                      ],
                    )
                  : Container(
                      height: 0,
                    ),
              SizedBox(
                height: widget.order.isReturn == 0 ? 8 : 0,
              ),
              widget.order.isReturn == 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "total_commission_key".tr(),
                          style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w600, color: TextGrey),
                        ),
                        Text(
                          "\u20B9 $totalComission",
                          style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                        ),
                      ],
                    )
                  : Text(""),
              SizedBox(
                height: widget.order.isReturn == 0 ? 20 : 0,
              ),
              widget.order.isReturn == 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "customer_amt_paid_key".tr(),
                          style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w600, color: TextGrey),
                        ),
                        // Row(children: [
                        double.parse(widget.order.orderTotal) >= (reddem / 3)
                            ? Text(
                                "\u20B9 ${(double.parse(widget.order.orderTotal)).toStringAsFixed(2)}",
                                style: GoogleFonts.openSans(
                                    fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                              )
                            : Text(
                                "\u20B9 0",
                                style: GoogleFonts.openSans(
                                    fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                              ),
                        // Image.asset(
                        //   "assets/images/point.png",
                        //   scale: 4,
                        // ),
                        // Text(
                        //   "${(reddem * 3).toStringAsFixed(2)})",
                        //   style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                        // ),
                        // ])
                        /* widget.order.orderType == 1
                                ? widget.order.orderDetails[0].redeemCoins == "0"
                                    ? Text(
                                        "\u20B9 0",
                                        style:
                                             GoogleFonts.openSans(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                                      )
                                    : Text(
                                        "\u20B9-${widget.order.orderDetails[0].redeemCoins}",
                                        style:
                                             GoogleFonts.openSans(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                                      )

                                : widget.order.billingDetails[0].redeemedCoins == "0"
                                    ? Text(
                                        "\u20B9 0",
                                        style:
                                             GoogleFonts.openSans(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                                      )
                                    : Text(
                                        "\u20B9-${widget.order.billingDetails[0].redeemedCoins}",
                                        style:
                                             GoogleFonts.openSans(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                                      ),*/
                      ],
                    )
                  : Container(
                      height: 0,
                    ),
              SizedBox(
                height: widget.order.isReturn == 0 ? 8 : 0,
              ),
              widget.order.isReturn == 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoSizeText(
                          "customer_redemption_key".tr(),
                          minFontSize: 14,
                          maxFontSize: 16,
                          style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w600, color: TextGrey),
                        ),
                        Row(children: [
                          AutoSizeText(
                            "(",
                            minFontSize: 14,
                            maxFontSize: 16,
                            style:
                                GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                          ),
                          Image.asset(
                            "assets/images/point.png",
                            scale: 4,
                          ),
                          AutoSizeText(
                            "${(reddem).toStringAsFixed(2)}) ",
                            minFontSize: 14,
                            maxFontSize: 16,
                            style:
                                GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                          ),
                          AutoSizeText(
                            "\u20B9 ${(reddem / 3).toStringAsFixed(2)}",
                            minFontSize: 14,
                            maxFontSize: 16,
                            style:
                                GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                          ),
                        ])
                        /* widget.order.orderType == 1
                                ? widget.order.orderDetails[0].redeemCoins == "0"
                                    ? Text(
                                        "\u20B9 0",
                                        style:
                                             GoogleFonts.openSans(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                                      )
                                    : Text(
                                        "\u20B9-${widget.order.orderDetails[0].redeemCoins}",
                                        style:
                                             GoogleFonts.openSans(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                                      )

                                : widget.order.billingDetails[0].redeemedCoins == "0"
                                    ? Text(
                                        "\u20B9 0",
                                        style:
                                             GoogleFonts.openSans(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                                      )
                                    : Text(
                                        "\u20B9-${widget.order.billingDetails[0].redeemedCoins}",
                                        style:
                                             GoogleFonts.openSans(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                                      ),*/
                      ],
                    )
                  : Container(),
              SizedBox(
                height: widget.order.isReturn == 0 ? 20 : 0,
              ),
              widget.order.isReturn == 0
                  ? Container(
                      height: 1,
                      color: Colors.black,
                    )
                  : Container(),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "net_settlement_amount_key".tr(),
                        style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16, color: TextBlackLight),
                      ),
                      Text(
                        "(${"redemption_key".tr()} - ${"commission_key".tr()})",
                        style: GoogleFonts.openSans(fontWeight: FontWeight.w500, fontSize: 12, color: TextGrey),
                      ),
                    ],
                  ),
                  totalComission >= reddem / 3
                      ? Text(
                          "\u20B9${(totalComission - reddem / 3).toStringAsFixed(2)}",
                          style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 28, color: ColorPrimary),
                        )
                      : Text(
                          "\u20B9${(reddem / 3 - totalComission).toStringAsFixed(2)}",
                          style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 28, color: ColorPrimary),
                        ),
                ],
              ),
              //  Transaction By
            ],
          ),
        ),
        widget.order.isReturn == 1
            ? Padding(
                padding: const EdgeInsets.only(left: 14, right: 14, top: 14, bottom: 14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "sales_return_key".tr(),
                          style: GoogleFonts.openSans(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        InkWell(
                          onTap: () {
                            returnSummary();
                          },
                          child: Text(
                            "view_details_key".tr(),
                            style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: TextGrey),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "collection_amt_key".tr(),
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.bold, fontSize: 16, color: TextBlackLight),
                            ),
                            Text(
                              "(${"amount_paid_key".tr()} - ${"earn_coins_key".tr()})",
                              style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 12, color: TextGrey),
                            ),
                          ],
                        ),
                        Text(
                          "\u20B9${(returnCollectionAmnt).toStringAsFixed(2)}",
                          style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 28, color: ColorPrimary),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: 1,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text("final_ledger_key".tr(),
                          style:
                              GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold, color: TextBlackLight)),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "collection_amt_key".tr(),
                          style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16, color: TextGrey),
                        ),
                        Text(
                          "\u20B9 ${returnCollectionAmnt.toStringAsFixed(2)}",
                          style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16, color: TextBlackLight),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "commission_return_key".tr(),
                          style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16, color: TextGrey),
                        ),
                        Text(
                          "\u20B9 ${returnCommisionAmnt.toStringAsFixed(2)}",
                          style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16, color: TextBlackLight),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 1,
                      color: Colors.black,
                      margin: EdgeInsets.only(bottom: 8),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "net_settlement_amount_key".tr(),
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.bold, fontSize: 16, color: TextBlackLight),
                            ),
                            Text(
                              "(${"commission_return_key".tr()} - ${"collection_amt_key".tr()})",
                              style: GoogleFonts.openSans(fontWeight: FontWeight.w500, fontSize: 11, color: TextGrey),
                            ),
                          ],
                        ),
                        returnCollectionAmnt >= returnCommisionAmnt
                            ? Text(
                                "\u20B9${(returnCollectionAmnt - returnCommisionAmnt).toStringAsFixed(2)}",
                                style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.w600, fontSize: 28, color: ColorPrimary),
                              )
                            : Text(
                                "\u20B9${(returnCommisionAmnt - returnCollectionAmnt).toStringAsFixed(2)}",
                                style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.w600, fontSize: 28, color: ColorPrimary),
                              ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )
            : Container(),
      ],
    );
  }

  void invoice() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(25),
                topLeft: Radius.circular(25),
              ),
            ),
            child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 20),
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "billing_key".tr(),
                        style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold, color: TextBlackLight),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "totals_order_value_key".tr(),
                        style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w600, color: TextGrey),
                      ),
                      Text(
                        "\u20B9 ${orderTotal.toStringAsFixed(2)}",
                        style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "total_commission_key".tr(),
                        style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w600, color: TextGrey),
                      ),
                      Text(
                        "\u20B9 $totalComission",
                        style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "customer_amt_paid_key".tr(),
                        style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w600, color: TextGrey),
                      ),
                      // Row(children: [
                      double.parse(widget.order.orderTotal) >= reddem / 3
                          ? Text(
                              "\u20B9 ${(double.parse(widget.order.orderTotal)).toStringAsFixed(2)}",
                              style: GoogleFonts.openSans(
                                  fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                            )
                          : Text(
                              "\u20B9 0",
                              style: GoogleFonts.openSans(
                                  fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                            ),
                    ],
                  ),

                  SizedBox(
                    height: 8,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(
                        "customer_redemption_key".tr(),
                        minFontSize: 14,
                        maxFontSize: 14,
                        style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w600, color: TextGrey),
                      ),
                      Row(children: [
                        AutoSizeText(
                          "(",
                          minFontSize: 14,
                          maxFontSize: 16,
                          style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                        ),
                        Image.asset(
                          "assets/images/point.png",
                          scale: 4,
                        ),
                        AutoSizeText(
                          "${(reddem).toStringAsFixed(2)}) ",
                          minFontSize: 14,
                          maxFontSize: 16,
                          style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                        ),
                        AutoSizeText(
                          "\u20B9 ${(reddem / 3).toStringAsFixed(2)}",
                          minFontSize: 14,
                          maxFontSize: 16,
                          style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                        ),
                      ])
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 1,
                    color: Colors.black,
                  ),

                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "net_settlement_amount_key".tr(),
                            style:
                                GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16, color: TextBlackLight),
                          ),
                          Text(
                            "(${"redemption_key".tr()} - ${"commission_key".tr()})",
                            style: GoogleFonts.openSans(fontWeight: FontWeight.w500, fontSize: 12, color: TextGrey),
                          ),
                        ],
                      ),
                      totalComission >= reddem / 3
                          ? Text(
                              "\u20B9${(totalComission - (reddem / 3)).toStringAsFixed(2)}",
                              style:
                                  GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 28, color: ColorPrimary),
                            )
                          : Text(
                              "\u20B9${((reddem / 3) - totalComission).toStringAsFixed(2)}",
                              style:
                                  GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 28, color: ColorPrimary),
                            ),
                    ],
                  ),
                  //  Transaction By

                  Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "To: MyProfit",
                                style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16, color: TextGrey),
                              ),
                              Text(
                                "From: George Walker",
                                style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16, color: TextGrey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    height: 50,
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Close",
                        style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold, color: TextGrey),
                      ),
                    ),
                  )
                ])));
      },
    );
  }

  void returnSummary() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(25),
                topLeft: Radius.circular(25),
              ),
            ),
            child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 20),
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "return_summary_key".tr(),
                        style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold, color: TextBlackLight),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "customer_amt_paid_key".tr(),
                        style: GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.w600, color: TextGrey),
                      ),
                      Text(
                        "\u20B9 ${(returnAmountpaid).toStringAsFixed(2)}",
                        style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "customer_redemption_key".tr(),
                        style: GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.w600, color: TextGrey),
                      ),
                      Row(children: [
                        AutoSizeText(
                          "(",
                          minFontSize: 14,
                          maxFontSize: 16,
                          style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                        ),
                        Image.asset(
                          "assets/images/point.png",
                          scale: 4,
                        ),
                        AutoSizeText(
                          "${(returnRedemption).toStringAsFixed(2)}) ",
                          minFontSize: 14,
                          maxFontSize: 16,
                          style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                        ),
                        AutoSizeText(
                          "\u20B9 ${(returnRedemption / 3).toStringAsFixed(2)}",
                          minFontSize: 14,
                          maxFontSize: 16,
                          style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                        ),
                      ])
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "coins_earned__by_customer_key".tr(),
                        style: GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.w600, color: TextGrey),
                      ),
                      // Row(children: [

                      Row(children: [
                        AutoSizeText(
                          "(",
                          minFontSize: 14,
                          maxFontSize: 16,
                          style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                        ),
                        Image.asset(
                          "assets/images/point.png",
                          scale: 4,
                        ),
                        AutoSizeText(
                          "${(returnEarned.toStringAsFixed(2))}) ",
                          minFontSize: 14,
                          maxFontSize: 16,
                          style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                        ),
                        AutoSizeText(
                          "\u20B9 ${(returnEarned / 3).toStringAsFixed(2)}",
                          minFontSize: 14,
                          maxFontSize: 16,
                          style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                        ),
                      ])
                    ],
                  ),

                  SizedBox(
                    height: 8,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(
                        "current_coin_balance_key".tr(),
                        minFontSize: 14,
                        maxFontSize: 14,
                        style: GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.w600, color: TextGrey),
                      ),
                      Row(children: [
                        AutoSizeText(
                          "(",
                          minFontSize: 14,
                          maxFontSize: 16,
                          style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                        ),
                        Image.asset(
                          "assets/images/point.png",
                          scale: 4,
                        ),
                        AutoSizeText(
                          "${(double.parse(details!.customerCoinBalance)).toStringAsFixed(2)}) ",
                          minFontSize: 14,
                          maxFontSize: 16,
                          style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                        ),
                        AutoSizeText(
                          "\u20B9 ${(double.parse(details!.customerCoinBalance) / 3).toStringAsFixed(2)}",
                          minFontSize: 14,
                          maxFontSize: 16,
                          style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                        ),
                      ])
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 1,
                    color: Colors.black,
                  ),

                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "collection_amt_key".tr(),
                            style:
                                GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16, color: TextBlackLight),
                          ),
                          Text(
                            "(${"amount_paid_key".tr()} - ${"collection_amt_key".tr()})",
                            style: GoogleFonts.openSans(fontWeight: FontWeight.w500, fontSize: 12, color: TextGrey),
                          ),
                        ],
                      ),
                      Text(
                        "\u20B9${(returnCollectionAmnt).toStringAsFixed(2)}",
                        style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 28, color: ColorPrimary),
                      ),
                    ],
                  ),
                  //  Transaction By

                  Container(
                    height: 50,
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Close",
                        style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold, color: TextGrey),
                      ),
                    ),
                  )
                ])));
      },
    );
  }
}

class DirectBillingListItem extends StatelessWidget {
  final String commission;

  final BillingDetail detail;

  const DirectBillingListItem({Key? key, required this.detail, required this.commission}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
                // boxShadow: [
                //   BoxShadow(
                //       color: Colors.black12,
                //       spreadRadius: 4,
                //       blurRadius: 10)
                // ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          child: Image.asset(
                            "assets/images/account-ic6.png",
                            height: 45,
                            width: 45,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Flexible(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${detail.categoryName}",
                                  style: GoogleFonts.openSans(
                                      fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                Text(
                                  "\u20B9 ${detail.amountPaid}",
                                  style: GoogleFonts.openSans(
                                      fontSize: 13, fontWeight: FontWeight.bold, color: ColorPrimary),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${"commission_key".tr()} \u20B9${commission}",
                                  style: GoogleFonts.openSans(
                                      fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          double.parse(detail.redeemCoins) > 0
              ? Positioned(
                  top: 4,
                  right: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: RejectedTextBgColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 4, blurRadius: 10)],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5, top: 1, bottom: 1),
                      child: Text(
                        "redeemed_key".tr(),
                        style: GoogleFonts.openSans(color: RejectedTextColor, fontWeight: FontWeight.bold, fontSize: 9),
                      ),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
