import 'dart:async';
import 'dart:collection';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:timeline_tile/timeline_tile.dart';
import 'package:vendor/main.dart';
import 'package:vendor/ui/money_due_upi/redeem_coin/customer_coin_history_response.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/network.dart';

class SalesReturnDetailsSheet extends StatefulWidget {
  final String customerId;
  SalesReturnDetailsSheet({required this.customerId, Key? key})
      : super(key: key);

  @override
  State<SalesReturnDetailsSheet> createState() =>
      _SalesReturnDetailsSheetState();
}

class _SalesReturnDetailsSheetState extends State<SalesReturnDetailsSheet> {
  StreamController<List<RedeemData>> streamController = StreamController();
  @override
  void initState() {
    super.initState();
    getRedeemCoinHistory();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: SingleChildScrollView(
            primary: false,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("redeem_history_key".tr(),
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 14,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.43,
                  child: StreamBuilder<List<RedeemData>>(
                    stream: streamController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasData) {
                        return ListView.builder(
                          padding: const EdgeInsets.only(
                            left: 10,
                          ),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return TimelineTile(
                              alignment: TimelineAlign.start,
                              lineXY: 0.1,
                              isFirst: index == 0 ? true : false,
                              isLast: index == snapshot.data!.length - 1
                                  ? true
                                  : false,
                              indicatorStyle: const IndicatorStyle(
                                width: 14,
                                color: Colors.red,
                                padding: EdgeInsets.all(0),
                              ),
                              beforeLineStyle: const LineStyle(
                                  color: Colors.red, thickness: 3),
                              endChild: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 14, top: 8, bottom: 14),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 70,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 6,
                                              color: Colors.black12,
                                              spreadRadius: 2)
                                        ],
                                      ),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 14),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${snapshot.data![index].vendorName}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87),
                                            ),
                                            Text(
                                              "${DateFormat("dd MMM yyyy").format(DateTime.parse(snapshot.data![index].dateTime))} ${DateFormat.jm().format(DateTime.parse(snapshot.data![index].dateTime)).toLowerCase()}",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: Container(
                                        height: 70,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.18,
                                        decoration: BoxDecoration(
                                          color: RejectedBoxBgColor,
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 6,
                                                color: Colors.black12,
                                                spreadRadius: 2)
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/images/point.png",
                                              width: 18,
                                              height: 18,
                                            ),
                                            AutoSizeText(
                                              "${double.parse(snapshot.data![index].spendCoins).toStringAsFixed(0)}",
                                              minFontSize: 14,
                                              maxFontSize: 18,
                                              style: TextStyle(
                                                  color: RejectedTextColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          shrinkWrap: true,
                        );
                      }
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        child: Image.asset("assets/images/no_data.gif"),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "close_key".tr(),
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getRedeemCoinHistory() async {
    Map<String, dynamic> input = HashMap();

    input['customer_id'] = widget.customerId;

    if (await Network.isConnected()) {
      CustomerRedeemCoinHistory redeemCoinHistory =
          await apiProvider.redeemCoinHistory(input);
      if (redeemCoinHistory.success) {
        streamController.add(redeemCoinHistory.data);
      }
    }
  }
}
