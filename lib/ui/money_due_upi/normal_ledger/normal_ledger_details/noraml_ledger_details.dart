import 'dart:collection';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/model/normal_ladger_response.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/normal_ledger_details/normal_ledger_detail_bloc/normal_ledger_detail_bloc.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/normal_ledger_details/normal_ledger_detail_bloc/normal_ledger_detail_event.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/normal_ledger_details/normal_ledger_detail_bloc/normal_ledger_detail_state.dart';
import 'package:vendor/ui/money_due_upi/sales_return/response/upi_sales_return_response.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/sharedpref.dart';

class NormalLedgerDetails extends StatefulWidget {
  // final List<OrderData> commonLedgerHistory;
  final OrderData order;

  // final int index;
  NormalLedgerDetails({Key? key, required this.order}) : super(key: key);

  @override
  State<NormalLedgerDetails> createState() => _NormalLedgerDetailsState();
}

class _NormalLedgerDetailsState extends State<NormalLedgerDetails> {
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
  NormalLedgerDetailBloc normalLedgerDetailBloc = NormalLedgerDetailBloc();
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

  getNormalLedgerData() async {
    var vendorId = await SharedPref.getIntegerPreference(SharedPref.VENDORID);

    Map<String, dynamic> input = HashMap();
    input['vendor_id'] = vendorId;
    input['order_id'] = widget.order.orderId;
    input["from_date"] = "";
    input["to_date"] = "";
    normalLedgerDetailBloc.add(GetNormalLedgerDetailHistoryEvent(input: input));
  }

  void calculation() {
    if (widget.order.orderType == 1) {
      reddem = double.parse(widget.order.billingDetails.first.redeemCoins);
      if (double.parse(widget.order.myprofitRevenue) > reddem) {
        log("${double.parse(widget.order.myprofitRevenue)}");
        finalamount = double.parse(widget.order.myprofitRevenue) - reddem;
      } else {
        finalamount = reddem - double.parse(widget.order.myprofitRevenue);
      }
    } else {
      // getNormalLedgerData();
      widget.order.orderDetails.forEach((element) {
        reddem += double.parse(element.redeemCoins);
        log("$reddem");
        if (double.parse(widget.order.myprofitRevenue) > reddem) {
          log("${double.parse(widget.order.myprofitRevenue)}");
          finalamount = double.parse(widget.order.myprofitRevenue) - reddem;
        } else {
          finalamount = reddem - double.parse(widget.order.myprofitRevenue);
        }
      });
    }
  }

  void salesreturnCalculations() {
    for (var products in details!.orderDetails) {
      CommonSaleReturnProductDetails normalBillingProducts = CommonSaleReturnProductDetails(
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
      );
      productDetails.add(normalBillingProducts);
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
    return BlocProvider<NormalLedgerDetailBloc>(
      create: (context) => normalLedgerDetailBloc,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Text(
            "Normal Ledger Details",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: widget.order.isReturn == 1
                ? BlocBuilder<NormalLedgerDetailBloc, NormalLedgerDetailStates>(builder: ((context, state) {
                    if (state is NormalLedgerDetailInitialState) {
                      getNormalLedgerData();
                    }
                    if (state is NormalLedgerDetailHistoryState) {
                      billingDetails = state.response;
                      details = billingDetails.first;

                      salesreturnCalculations();
                    }
                    if (state is NormalLedgerDetailLoadingState) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is NormalLedgerDetailFailureState) {
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
          padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 4, blurRadius: 10)],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${widget.order.firstName}",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      Text(
                        "${DateFormat("yyyy MM dd ").format(widget.order.dateTime)}(${DateFormat.jm().format(widget.order.dateTime)})",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "+91 ${widget.order.mobile}",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: widget.order.status == 1 ? PendingTextBgColor : GreenBoxBgColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                          child: widget.order.status == 1
                              ? Text(
                                  "Pending",
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: RejectedTextColor),
                                )
                              : Text(
                                  "Paid",
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: GreenBoxTextColor),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 4, blurRadius: 10)],
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14, top: 10),
                    child: Text(
                      "All Items",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                widget.order.orderType == 1
                    ? DirectBillingListItem(
                        commission: widget.order.myprofitRevenue,
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
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black87),
                                                      ),
                                                      Text(
                                                        "\u20B9 ${widget.order.orderDetails[index].total}",
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.bold,
                                                            color: ColorPrimary),
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
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.grey),
                                                      ),
                                                      Text(
                                                        "Commission \u20B9${widget.order.myprofitRevenue}",
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black87),
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
                                              style: TextStyle(
                                                  color: RejectedTextColor, fontWeight: FontWeight.bold, fontSize: 10),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            );
                          }),
                        ),
                      ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14, right: 14, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Amount Paid By Customer",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      Text(
                        "\u20B9 ${widget.order.orderTotal}",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: ColorPrimary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 4, blurRadius: 10)],
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Commission Amount",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
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
                        "Total Commission",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      Text(
                        "\u20B9${widget.order.myprofitRevenue}",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
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
                        "Redeemed Amount",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      Text(
                        "\u20B9 $reddem",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                      )
                      /* widget.order.orderType == 1
                                    ? widget.order.orderDetails[0].redeemCoins == "0"
                                        ? Text(
                                            "\u20B9 0",
                                            style:
                                                TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                                          )
                                        : Text(
                                            "\u20B9-${widget.order.orderDetails[0].redeemCoins}",
                                            style:
                                                TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                                          )

                                    : widget.order.billingDetails[0].redeemedCoins == "0"
                                        ? Text(
                                            "\u20B9 0",
                                            style:
                                                TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                                          )
                                        : Text(
                                            "\u20B9-${widget.order.billingDetails[0].redeemedCoins}",
                                            style:
                                                TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                                          ),*/
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 20),
          child: double.parse(widget.order.myprofitRevenue) > reddem
              ? Container(
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      // stops: [0.1, 0.5, 0.7, 0.9],
                      colors: [
                        RedLightColor,
                        RedDarkColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 4, blurRadius: 10)],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Amount Paid To My Profit",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          "\u20B9 $finalamount",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      // stops: [0.1, 0.5, 0.7, 0.9],
                      colors: [
                        GreenLightColor,
                        GreenDarkColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 4, blurRadius: 10)],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Amount Paid To Vendor",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          "\u20B9 $finalamount",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        widget.order.isReturn == 1
            ? Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 4, blurRadius: 10)],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14, right: 14, top: 14, bottom: 14),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Sales Return History",
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            Text(
                              "${DateFormat("dd MMM yyyy").format(DateTime.parse(details!.dateTime))}  " +
                                  "${DateFormat.jm().format(DateTime.parse(details!.dateTime)).toLowerCase()}",
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
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
                              "Earn Coins",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/point.png",
                                  width: 14,
                                  height: 14,
                                ),
                                Text(
                                  "$earnCoins (\u20B9 ${(earnCoins / 3).toStringAsFixed(2)})",
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                                ),
                              ],
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
                              "Redeem Coins",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/point.png",
                                  width: 14,
                                  height: 14,
                                ),
                                Text(
                                  "${(redeemCoins).toStringAsFixed(2)} (\u20B9 ${(redeemCoins / 3).toStringAsFixed(2)}",
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green),
                                ),
                              ],
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
                              "Customer Coins Balance",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/point.png",
                                  width: 14,
                                  height: 14,
                                ),
                                Text(
                                  "${details!.customerCoinBalance} (\u20B9 ${(double.parse(details!.customerCoinBalance) / 3).toStringAsFixed(2)})",
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                              ],
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
                              "Net Balance",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/point.png",
                                  width: 14,
                                  height: 14,
                                ),
                                Text(
                                  "${(netBalance).toStringAsFixed(2)}  (\u20B9${(netBalance / 3).toStringAsFixed(2)})",
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                                ),
                              ],
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
                              "Amount Return to Customer",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/point.png",
                                  width: 14,
                                  height: 14,
                                ),
                                netBalance == 0
                                    ? Text(
                                        "\u20B9 $amtPaid",
                                        style:
                                            TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                                      )
                                    : Text(
                                        "\u20B9 ${(amtPaid - netBalance).toStringAsFixed(2)}",
                                        style:
                                            TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                                      ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Sum(\u20B9 $amtPaid  - \u20B9 $netBalance = \u20B9 ${(amtPaid - netBalance).toStringAsFixed(2)})",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Container(),
        widget.order.isReturn == 1
            ? Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 4, blurRadius: 10)],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 14),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Sales Return History",
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
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
                              "Amount Return To Vendor",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            Text(
                              "\u20B9${details!.amountPaidToVendor}",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
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
                              "Amount Return To MyProfit",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            Text(
                              "\u20B9 ${details!.amountPaidToMyProfit}",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                            )
                            /* widget.order.orderType == 1
                                    ? widget.order.orderDetails[0].redeemCoins == "0"
                                        ? Text(
                                            "\u20B9 0",
                                            style:
                                                TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                                          )
                                        : Text(
                                            "\u20B9-${widget.order.orderDetails[0].redeemCoins}",
                                            style:
                                                TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                                          )

                                    : widget.order.billingDetails[0].redeemedCoins == "0"
                                        ? Text(
                                            "\u20B9 0",
                                            style:
                                                TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                                          )
                                        : Text(
                                            "\u20B9-${widget.order.billingDetails[0].redeemedCoins}",
                                            style:
                                                TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                                          ),*/
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Container(),
        widget.order.isReturn == 1
            ? Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 20),
                child: double.parse(details!.amountPaidToMyProfit) < double.parse(details!.amountPaidToVendor)
                    ? Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            // stops: [0.1, 0.5, 0.7, 0.9],
                            colors: [
                              RedLightColor,
                              RedDarkColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 4, blurRadius: 10)],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Amount Paid To My Profit",
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              Text(
                                "\u20B9 $finalamount",
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            // stops: [0.1, 0.5, 0.7, 0.9],
                            colors: [
                              GreenLightColor,
                              GreenDarkColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 4, blurRadius: 10)],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Amount Paid To Vendor",
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              Text(
                                "\u20B9 $finalamount",
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
              )
            : Container(),
      ],
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
                          color: Colors.amber,
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
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                Text(
                                  "\u20B9 ${detail.amountPaid}",
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: ColorPrimary),
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
                                  "sadasd",
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                                ),
                                Text(
                                  "Commission \u20B9${commission}",
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87),
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
                        "Redeemed",
                        style: TextStyle(color: RejectedTextColor, fontWeight: FontWeight.bold, fontSize: 9),
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
