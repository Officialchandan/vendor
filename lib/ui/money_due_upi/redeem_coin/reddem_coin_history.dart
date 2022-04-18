import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vendor/ui/money_due_upi/redeem_coin/bloc/upi_redeem_coin_bloc.dart';
import 'package:vendor/ui/money_due_upi/redeem_coin/bloc/upi_redeem_coin_event.dart';
import 'package:vendor/ui/money_due_upi/redeem_coin/bloc/upi_redeem_coin_state.dart';
import 'package:vendor/ui/money_due_upi/redeem_coin/redeem_coin_details/redeem_coin_detalis.dart';
import 'package:vendor/ui/money_due_upi/redeem_coin/response/redeem_coin_response.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/sharedpref.dart';

import '../../../widget/calendar_bottom_sheet.dart';

class ReddemCoinHistory extends StatefulWidget {
  const ReddemCoinHistory({Key? key}) : super(key: key);

  @override
  _ReddemCoinHistoryState createState() => _ReddemCoinHistoryState();
}

class _ReddemCoinHistoryState extends State<ReddemCoinHistory> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  TextEditingController searchController = TextEditingController();
  RedeemCoinBloc redeemCoinBloc = RedeemCoinBloc();
  List<CoinDetail> redeemData = [];
  List<CoinDetail> searchList = [];
  String startDate = "";
  String endDate = "";

  @override
  void initState() {
    super.initState();
    getRedeemCoin("", "");
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => redeemCoinBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "redeem_coins_key".tr(),
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
                            getRedeemCoin(startDate, endDate);
                            // getCustomer();
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
            getRedeemCoin("", "");
          },
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15, top: 15),
                  child: TextFormField(
                    controller: searchController,
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
                      redeemCoinBloc.add(RedeemDataSearchEvent(keyWord: value));
                    },
                  ),
                ),
                Expanded(
                  child: BlocBuilder<RedeemCoinBloc, RedeemCoinStates>(
                    builder: (context, state) {
                      if (state is RedeemCoinLoadingState) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is RedeemCoinFailureState) {
                        return Center(
                          child: Image.asset("assets/images/no_data.gif"),
                        );
                      }
                      if (state is GetRedeemCoinState) {
                        redeemData = state.data;
                      }
                      if (state is GetSearchDataState) {
                        if (state.data.isEmpty) {
                          searchList = redeemData;
                        } else {
                          List<CoinDetail> list = [];
                          redeemData.forEach((element) {
                            if (element.productName.toLowerCase().contains(state.data.toLowerCase())) {
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
                              padding: EdgeInsets.only(left: 15, right: 15),
                              itemCount: searchList.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  child: DirectBillingList(detail: searchList[index]),
                                );
                              },
                            );
                          }
                        }
                      }
                      return ListView.builder(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        itemCount: redeemData.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: DirectBillingList(detail: redeemData[index]),
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  getRedeemCoin(String fromDate, String toDate) async {
    int vendorId = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
    Map<String, dynamic> input = HashMap();
    input["from_date"] = fromDate;
    input["to_date"] = toDate;
    input["vendor_id"] = vendorId;
    redeemCoinBloc.add(GetRedeemCoinDataEvent(input: input));
    _refreshController.refreshCompleted();
  }
}

class DirectBillingList extends StatefulWidget {
  final CoinDetail detail;
  const DirectBillingList({Key? key, required this.detail}) : super(key: key);

  @override
  State<DirectBillingList> createState() => _DirectBillingListState();
}

class _DirectBillingListState extends State<DirectBillingList> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        margin: EdgeInsets.only(top: 15),
        padding: EdgeInsets.all(0),
        height: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(color: Colors.white38),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1.0, spreadRadius: 1)]),
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RedeemCoinDetails(
                          detail: widget.detail,
                        )));
          },
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(width: 10),
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Image.network("${widget.detail.image}"),
            ),
            Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.detail.productName}",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text("${"mobile_key".tr()}: ${widget.detail.mobile}"),
                    Container(
                      height: 20,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.grey.shade200),
                      child: Row(children: [
                        Text(
                          "  ${"redeemed_key".tr()}: ",
                          style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                        Image.asset("assets/images/point.png"),
                        Text(
                          "${(double.parse(widget.detail.totalRedeemCoins)).toStringAsFixed(2)} (\u20B9 ${(double.parse(widget.detail.totalRedeemCoins) / 3).toStringAsFixed(2)})",
                          style: TextStyle(color: ColorPrimary, fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                      ]),
                    ),
                  ]),
            ),
          ]),
        ),
      ),
    ]);
  }
}
