import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/ui/inventory/suggested_product/bloc/suggested_product_bloc.dart';
import 'package:vendor/ui/inventory/suggested_product/bloc/suggested_product_event.dart';
import 'package:vendor/ui/inventory/suggested_product/bloc/suggested_product_state.dart';

class SuggestedProductScreen extends StatefulWidget {
  @override
  _SuggestedProductScreenState createState() => _SuggestedProductScreenState();
}

class _SuggestedProductScreenState extends State<SuggestedProductScreen> with TickerProviderStateMixin {
  final List<String> tabs = ["ADIDAS", "PUMA", "NIKE", "BATA", "LANCER", "REBOOK", "GOLD STAR"];
  TabController? _tabController;
  int currentIndex = 0;

  SuggestedProductBloc suggestedProductBloc = SuggestedProductBloc();

  @override
  void initState() {
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController!.addListener(() => onTabChange(_tabController!.index));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return suggestedProductBloc;
      },
      child: BlocListener<SuggestedProductBloc, SuggestedProductState>(
        listener: (context, state) {},
        child: DefaultTabController(
          length: tabs.length,
          child: Scaffold(
            appBar: AppBar(
              title: Text("Add Suggested Product"),
              bottom: TabBar(
                isScrollable: true,
                controller: _tabController,
                onTap: (index) {
                  suggestedProductBloc.add(ChangeTabEvent(index: index));
                },
                tabs: tabs
                    .map((e) => Tab(
                          text: e,
                        ))
                    .toList(),
              ),
            ),
            body: BlocBuilder<SuggestedProductBloc, SuggestedProductState>(
              builder: (context, state) {
                if (state is ChangeTabState) {
                  currentIndex = state.index;
                  suggestedProductBloc.add(GetProductEvent());
                  return CircularProgressIndicator();
                }

                if (state is GetProductState) {
                  return Center(child: Text(tabs[currentIndex]));
                }
                return Center(child: Text(tabs[currentIndex]));
              },
            ),
          ),
        ),
      ),
    );
  }

  onTabChange(int index) {
    setState(() {});
  }
}

class TabViewWidget extends StatefulWidget {
  final int index;
  final String name;

  TabViewWidget({required this.index, required this.name});

  @override
  _TabViewWidgetState createState() => _TabViewWidgetState();
}

class _TabViewWidgetState extends State<TabViewWidget> {
  @override
  void initState() {
    super.initState();
    print("tab index -> ${widget.index}");
    print("tab name -> ${widget.name}");
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Center(
      child: Text(widget.name),
    ));
  }
}
