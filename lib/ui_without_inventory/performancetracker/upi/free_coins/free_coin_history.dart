import 'dart:collection';
import 'dart:developer';
import 'package:vendor/widget/progress_indecator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/model/normal_ladger_response.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/free_coins/bloc/free_coin_history_bloc.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/free_coins/bloc/free_coin_history_event.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/free_coins/bloc/free_coin_history_state.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/free_coins/free_coin_detail.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/widget/calendar_bottom_sheet.dart';

class FreeCoinsHistory extends StatefulWidget {
  const FreeCoinsHistory({Key? key}) : super(key: key);

  @override
  _FreeCoinsHistoryState createState() => _FreeCoinsHistoryState();
}

class _FreeCoinsHistoryState extends State<FreeCoinsHistory> {
  String startDate = "";
  String endDate = "";
  double earning = 0;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  TextEditingController _searchController = TextEditingController();
  FreeCoinHistoryBloc freeCoinHistoryBloc = FreeCoinHistoryBloc();
  List<OrderData> searchList = [];
  List<OrderData>? freecoinsdata;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> filterApiCall(BuildContext context) async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["from_date"] = startDate.isEmpty ? "" : startDate.toString();
    input["to_date"] = endDate.isEmpty ? startDate.toString() : endDate.toString();
    input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
    log("=====? $input");
    freeCoinHistoryBloc.add(GetFreeCoinsHistoryEvent(input: input));
  }

  void calculation() {
    if (searchList[0].orderType == 1) {
      earning = double.parse(searchList[0].billingDetails.first.earningCoins);
    } else {
      searchList[0].orderDetails.forEach((element) {
        earning += double.parse(element.earningCoins);
        log("$earning");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FreeCoinHistoryBloc>(
      create: (context) => freeCoinHistoryBloc,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "free_coins_key".tr(),
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
                            print("startDate->$startDate");
                            print("endDate->$endDate");
                            filterApiCall(context);
                            // getCustomer();
                          });
                    });
                print("startDate---1>$startDate");
                print("endDate---1>$endDate");
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
            filterApiCall(context);
          },
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(left: 14, right: 14, top: 14),
              child: TextFormField(
                cursorColor: ColorPrimary,
                controller: _searchController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                onChanged: (text) {
                  freeCoinHistoryBloc.add(FindUserEvent(searchkeyword: text));
                },
              ),
            ),
            SizedBox(
              height: 5,
            ),
            BlocBuilder<FreeCoinHistoryBloc, FreeCoinHistoryState>(builder: (context, state) {
              if (state is GetFreeCoinHistoryInitialState) {
                filterApiCall(context);
              }
              if (state is GetFreeCoinHistoryState) {
                freecoinsdata = state.data;
                searchList = freecoinsdata!;
              }
              if (state is GetFreeCoinHistoryLoadingState) {
                return Container(
                    height: MediaQuery.of(context).size.height * 0.70,
                    child: Center(child: CircularLoader()));
              }
              if (state is GetFreeCoinUserSearchState) {
                if (state.searchword.isEmpty) {
                  searchList = freecoinsdata!;
                } else {
                  List<OrderData> list = [];
                  freecoinsdata!.forEach((element) {
                    if (element.mobile.toLowerCase().contains(state.searchword.toLowerCase())) {
                      list.add(element);
                      log("how much -->${state.searchword}");
                    }
                  });
                  if (list.isEmpty) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      child: Image.asset("assets/images/no_data.gif"),
                    );
                  } else {
                    searchList = list;
                    ListWidget(searchList);
                  }
                }
                if (state is GetFreeCoinHistoryFailureState) {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    child: Image.asset("assets/images/no_data.gif"),
                  );
                }
              }
              return ListWidget(searchList);
            }),
          ]),
        ),
      ),
    );
  }
}

class ListWidget extends StatefulWidget {
  List<OrderData> searchList = [];
  ListWidget(this.searchList);

  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          padding: EdgeInsets.only(left: 14, right: 14, bottom: 14),
          itemCount: widget.searchList.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(top: 14),
              padding: EdgeInsets.all(12),
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    offset: Offset(0.0, 0.0), //(x,y)
                    blurRadius: 7.0,
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  log("=======${widget.searchList[index]}");
                  Navigator.push(
                      context,
                      PageTransition(
                          child: FreeCoinDetail(freecoindetail: widget.searchList[index]),
                          type: PageTransitionType.fade));
                },
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "+91 ${widget.searchList[index].mobile}",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: TextBlackLight),
                          ),
                          Text(
                            "${DateFormat("dd MMM yyyy").format(widget.searchList[index].dateTime)}",
                            style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 13, color: TextGrey),
                          ),
                        ],
                      ),
                      Row(children: [
                        Text(
                          "${"earned_key".tr()}: ",
                          style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 13, color: TextGrey),
                        ),
                        Image.asset(
                          "assets/images/point.png",
                          scale: 2.5,
                        ),
                        widget.searchList[index].orderType == 0
                            ? Text(
                                " ${widget.searchList[index].totalearningcoins} ",
                                style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.bold, fontSize: 20, color: ColorPrimary),
                              )
                            : Text(
                                " ${widget.searchList[index].billingDetails[0].earningCoins} ",
                                style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.bold, fontSize: 20, color: ColorPrimary),
                              ),
                      ]),
                    ]),
              ),
            );
          }),
    );
  }
}
