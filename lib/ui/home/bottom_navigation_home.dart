import 'package:flutter/material.dart';
import 'package:vendor/ui/account_management/account_management_screen/account_management_screen.dart';
import 'package:vendor/ui/billingflow/billing/billing.dart';

import 'package:vendor/ui/inventory/inventory_screen.dart';
import 'package:vendor/ui/performanceandreports/Trackerandreports/tracker_and_performance.dart';
import 'package:vendor/utility/color.dart';

class BottomNavigationHome extends StatefulWidget {
  final int index;

  BottomNavigationHome({this.index = 0});

  @override
  _BottomNavigationHomeState createState() => _BottomNavigationHomeState();
}

class _BottomNavigationHomeState extends State<BottomNavigationHome>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: 6,
      initialIndex: widget.index,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      initialIndex: widget.index,
      child: Scaffold(
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            BillingScreen(),
            InventoryScreen(),
            Center(
              child: Text("E-shop"),
            ),
            Center(
              child: Text("Staff"),
            ),
            TrackerReportsScreen(),
            AccountManagementScreen(),
          ],
        ),
        // bottomNavigationBar: BottomBar(
        //   tabController: _tabController!,
        // ),
        bottomNavigationBar: MBottomNavigationBar(
          index: widget.index,
          onChange: (index) {
            _tabController!.animateTo(index);
          },
        ),
      ),
    );
  }
}

class BottomBar extends StatefulWidget {
  final TabController tabController;

  BottomBar({required this.tabController});

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  void didUpdateWidget(covariant BottomBar oldWidget) {
    oldWidget.createState();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    widget.tabController.addListener(() {
      debugPrint("Tab change--> ${widget.tabController.index}");
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: widget.tabController,
      indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
              width: 3, color: ColorPrimary, style: BorderStyle.solid),
          insets: EdgeInsets.fromLTRB(30, 0, 30, 54)),
      labelColor: ColorPrimary,
      unselectedLabelColor: Colors.grey.shade500,
      physics: NeverScrollableScrollPhysics(),
      onTap: (i) {
        // setState(() {});
      },
      tabs: [
        Tab(
          text: 'Billing',
          icon: widget.tabController.index == 0
              ? Image.asset(
                  "assets/images/f1-a.png",
                  scale: 2,
                )
              : Image.asset(
                  "assets/images/f1.png",
                  scale: 2,
                ),
          iconMargin: EdgeInsets.all(0),
        ),
        Tab(
          text: 'Inventory',
          icon: widget.tabController.index == 1
              ? Image.asset(
                  "assets/images/f2-a.png",
                  scale: 2,
                )
              : Image.asset(
                  "assets/images/f2.png",
                  scale: 2,
                ),
          iconMargin: EdgeInsets.all(0),
        ),
        Tab(
          text: 'E-Shop',
          icon: widget.tabController.index == 2
              ? Image.asset(
                  "assets/images/f3-a.png",
                  scale: 2,
                )
              : Image.asset(
                  "assets/images/f3.png",
                  scale: 2,
                ),
          iconMargin: EdgeInsets.all(0),
        ),
        Tab(
          text: 'Staff',
          icon: widget.tabController.index == 3
              ? Image.asset(
                  "assets/images/f4-a.png",
                  scale: 2,
                )
              : Image.asset(
                  "assets/images/f4.png",
                  scale: 2,
                ),
          iconMargin: EdgeInsets.all(0),
        ),
        Tab(
          text: 'Performance',
          icon: widget.tabController.index == 4
              ? Image.asset(
                  "assets/images/f5-a.png",
                  scale: 2,
                )
              : Image.asset(
                  "assets/images/f5.png",
                  scale: 2,
                ),
          iconMargin: EdgeInsets.all(0),
        ),
        Tab(
          text: 'Account',
          icon: widget.tabController.index == 5
              ? Image.asset(
                  "assets/images/f6-a.png",
                  scale: 2,
                )
              : Image.asset(
                  "assets/images/f6.png",
                  scale: 2,
                ),
          iconMargin: EdgeInsets.all(0),
        ),
      ],
    );
  }
}

class MBottomNavigationBar extends StatefulWidget {
  final int index;
  final Function(int index) onChange;

  MBottomNavigationBar({this.index = 0, required this.onChange});

  @override
  _MBottomNavigationBarState createState() => _MBottomNavigationBarState();
}

class _MBottomNavigationBarState extends State<MBottomNavigationBar> {
  int currentIndex = 0;

  @override
  void initState() {
    currentIndex = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      backgroundColor: Colors.white,
      selectedFontSize: 12,
      unselectedFontSize: 10,
      selectedItemColor: ColorPrimary,
      unselectedItemColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      iconSize: 15,
      onTap: (index) {
        currentIndex = index;
        widget.onChange(index);
        setState(() {});
      },
      mouseCursor: MouseCursor.uncontrolled,
      elevation: 5,
      items: [
        BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/f1.png",
              scale: 2,
            ),
            activeIcon: Image.asset(
              "assets/images/f1-a.png",
              scale: 2,
            ),
            label: "Billing"),
        BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/f2.png",
              scale: 2,
            ),
            activeIcon: Image.asset(
              "assets/images/f2-a.png",
              scale: 2,
            ),
            label: "Inventory"),
        BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/f3.png",
              scale: 2,
            ),
            activeIcon: Image.asset(
              "assets/images/f3-a.png",
              scale: 2,
            ),
            label: "E-Shop"),
        BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/f4.png",
              scale: 2,
            ),
            activeIcon: Image.asset(
              "assets/images/f4-a.png",
              scale: 2,
            ),
            label: "Staff"),
        BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/f5.png",
              scale: 2,
            ),
            activeIcon: Image.asset(
              "assets/images/f5-a.png",
              scale: 2,
            ),
            label: "Performance"),
        BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/f6.png",
              scale: 2,
            ),
            activeIcon: Image.asset(
              "assets/images/f6-a.png",
              scale: 2,
            ),
            label: "Account"),
      ],
    );
  }
}
