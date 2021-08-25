import 'dart:math';



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myprofit_vendorapp/localization/app_translations.dart';
import 'package:myprofit_vendorapp/utility/color.dart';



class TabContainer extends StatefulWidget {
  final int page;
  TabContainer(this.page);

  @override
  _TabContainerState createState() => _TabContainerState(page);
}

class _TabContainerState extends State<TabContainer>
    with TickerProviderStateMixin {
  late List<Widget> listScreens;

  late TabController _tabController;
  _TabContainerState(page);
  int selectedTab = 0;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController.addListener(_onTab);
    _tabController.animateTo(widget.page);

    super.initState();
    listScreens = [
      // BillingDashboard(),
      // PerformanceTracker(),
      // OutstandingAmount()
    ];
  }

  backPress() {}

  _onTab() {
    print("how are u");
    setState(() {
      selectedTab = _tabController.index;
    });
    print("how are u${_tabController.index}");
  }

  late DateTime currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "exit_warning");
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    var titleList = [
      "${AppTranslations.of(context)!.text("billing_dashboard_key")}",
      "${AppTranslations.of(context)!.text("performance_tracker_key")}",
      "${AppTranslations.of(context)!.text("outstanding_amount_key")}"
    ];
    return WillPopScope(
      onWillPop: () {
        if (_tabController.index == 0) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            SystemNavigator.pop();
            return Future.value(true);
          }
        } else {
          // Navigator.pop(context);
          //   _tabController.index == 3 ?
          //   Fluttertoast.showToast(msg: "HI")
          //   :
          Navigator.canPop(context);
          _tabController.animateTo(0);
        }
        return Future.value(false);

        // _tabController.index == 0
        //     ? SystemNavigator.pop()
        //     : _tabController.animateTo(0);
        // return Future.value(false);
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(102, 87, 244, 1),
            centerTitle: true,
            leading: Builder(
              builder: (BuildContext context) {
                return InkWell(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 15, 15, 15),
                    child: Image.asset("assets/images/3x/w-menu.png"),
                  ),
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            title: Text(titleList[_tabController.index],
                style: GoogleFonts.openSans(fontWeight: FontWeight.w600)),
          ),
          //drawer: MyDrawer(),
          body: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: listScreens),
          bottomNavigationBar: TabBar(
            controller: _tabController,
            //indicatorWeight: 10,
            // indicatorColor: ColorPrimary,
            //automaticIndicatorColorAdjustment: true,
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                    width: 3, color: ColorPrimary, style: BorderStyle.solid),
                insets: EdgeInsets.fromLTRB(30, 0, 30, 70)),
            labelColor: ColorPrimary,
            unselectedLabelColor: Colors.grey.shade500,
            tabs: [
              Tab(
                text: "${AppTranslations.of(context)!.text("billing_key")}",
                icon: selectedTab == 0
                    ? Image.asset(
                        "assets/images/f2-b (7).png",
                        scale: 8,
                      )
                    : Image.asset(
                        "assets/images/f2-b (6).png",
                        scale: 8,
                      ),
              ),
              Tab(
                text:
                    "${AppTranslations.of(context)!.text("performance__key")}",
                icon: selectedTab == 1
                    ? Image.asset(
                        "assets/images/f2-b (1).png",
                        scale: 8,
                      )
                    : Image.asset(
                        "assets/images/f2-b (8).png",
                        scale: 8,
                      ),
              ),
              Tab(
                text: "${AppTranslations.of(context)!.text("outstanding_key")}",
                icon: selectedTab == 2
                    ? Image.asset(
                        "assets/images/f2-b (3).png",
                        scale: 8,
                      )
                    : Image.asset(
                        "assets/images/f2-b (2).png",
                        scale: 8,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
