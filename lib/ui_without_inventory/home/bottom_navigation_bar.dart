import 'package:flutter/material.dart';
import 'package:vendor/ui_without_inventory/accountmanagement/account_management_without_inventory.dart';
import 'package:vendor/ui_without_inventory/chatpapdi_billing/chatpapdi_billing.dart';
import 'package:vendor/ui_without_inventory/performancetracker/performance_tracker.dart';

import 'package:vendor/utility/color.dart';

class BottomNavigationHomeWithOutInventory extends StatefulWidget {
  final int index;

  BottomNavigationHomeWithOutInventory({this.index = 0});

  @override
  _BottomNavigationHomeWithOutInventoryState createState() =>
      _BottomNavigationHomeWithOutInventoryState();
}

class _BottomNavigationHomeWithOutInventoryState
    extends State<BottomNavigationHomeWithOutInventory>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: 3,
      initialIndex: widget.index,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: widget.index,
      child: Scaffold(
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            ChatPapdiBilling(),
            PerformanceTrackerWithoutInventory(),
            AccountManagementWithoutInventoryScreen(),
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
          text: 'Performance',
          icon: widget.tabController.index == 1
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
          icon: widget.tabController.index == 2
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
