import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vendor/ui/money_due_upi/redeem_coin/response/redeem_coin_response.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/redeem_coins/bloc/redeem_coin_history_bloc.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/redeem_coins/bloc/redeem_coin_history_event.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/redeem_coins/bloc/redeem_coin_history_state.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/redeem_coins/redeem_coin_detail.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/widget/calendar_bottom_sheet.dart';

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
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
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
                  padding: const EdgeInsets.only(left: 14, right: 14, top: 14),
                  child: TextFormField(
                    controller: searchController,
                    keyboardType: TextInputType.number,
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
                            if (element.mobile.toLowerCase().contains(state.data.toLowerCase())) {
                              list.add(element);
                            }
                          });
                          if (list.isEmpty) {
                            return Container(
                              height: MediaQuery.of(context).size.height,
                              child: Image.asset("assets/images/no_data.gif"),
                            );
                          } else {
                            searchList = list;
                            return ListView.builder(
                              padding: EdgeInsets.only(left: 14, right: 14),
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
                        padding: EdgeInsets.only(left: 14, right: 14),
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
    return Container(
      margin: EdgeInsets.only(top: 14),
      padding: EdgeInsets.all(12),
      height: 80,
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
        splashColor: Colors.transparent,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RedeemCoinDetails(
                        detail: widget.detail,
                      )));
        },
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${widget.detail.mobile}",
                    style: TextStyle(color: TextBlackLight, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    "${DateFormat("dd MMM yyyy").format(DateTime.parse(widget.detail.dateTime))}",
                    style: GoogleFonts.openSans(color: TextBlackLight, fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ],
              ),
              Row(children: [
                Text(
                  "${"redeemed_key".tr()}: ",
                  style: GoogleFonts.openSans(color: TextGrey, fontWeight: FontWeight.w600, fontSize: 13),
                ),
                Image.asset(
                  "assets/images/point.png",
                  width: 14,
                ),
                Text(
                  "${widget.detail.totalRedeemCoins} ",
                  style: GoogleFonts.openSans(color: TextBlackLight, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  "(\u20B9${(double.parse(widget.detail.totalRedeemCoins) / 3).toStringAsFixed(2)})",
                  style: GoogleFonts.openSans(color: ColorPrimary, fontWeight: FontWeight.w600, fontSize: 20),
                ),
              ]),
            ]),
      ),
    );
  }
}
