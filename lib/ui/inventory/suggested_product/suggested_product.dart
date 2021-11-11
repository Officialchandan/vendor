import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/model/get_brands_response.dart';
import 'package:vendor/model/product_model.dart';
import 'package:vendor/ui/inventory/suggested_product/bloc/suggested_product_bloc.dart';
import 'package:vendor/ui/inventory/suggested_product/bloc/suggested_product_event.dart';
import 'package:vendor/ui/inventory/suggested_product/bloc/suggested_product_state.dart';
import 'package:vendor/ui/inventory/suggested_product/suggested_product_list.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/utility.dart';

class SuggestedProductScreen extends StatefulWidget {
  @override
  _SuggestedProductScreenState createState() => _SuggestedProductScreenState();
}

class _SuggestedProductScreenState extends State<SuggestedProductScreen> with TickerProviderStateMixin {
  List<Brand> tabs = [];
  TabController? _tabController;
  int currentIndex = 0;
  bool enabled = false;
  Map<String, List<ProductModel>> productMap = {};

  SuggestedProductBloc suggestedProductBloc = SuggestedProductBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return suggestedProductBloc;
      },
      child: BlocListener<SuggestedProductBloc, SuggestedProductState>(
        listener: (context, state) {
          if (state is CheckState) {
            productMap[tabs[_tabController!.index].brandName]![state.index].check = state.check;
            int i = -1;
            productMap.forEach((key, value) {
              i = i + value.where((element) => element.check).toList().length;
            });
            print("i->$i");
            if (i != -1) {
              enabled = true;
            } else {
              enabled = false;
            }
          }
          if (state is AddProductSuccessState) {
            Utility.showToast(state.message);
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Add Suggested Product"),
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(54),
                child: BlocBuilder<SuggestedProductBloc, SuggestedProductState>(
                  builder: (context, state) {
                    if (state is SuggestedProductInitialState) {
                      suggestedProductBloc.add(GetBrandsEvent());
                    }
                    if (state is GetBrandsState) {
                      tabs = state.brands;
                      _tabController = TabController(length: tabs.length, vsync: this);
                      suggestedProductBloc.add(GetProductEvent(brandId: tabs[0].brandName));
                    }
                    if (state is ChangeTabState) {
                      _tabController!.index = state.index;
                    }

                    if (_tabController == null || tabs.isEmpty) {
                      return Container();
                    }

                    return TabBar(
                      isScrollable: true,
                      controller: _tabController,
                      onTap: (index) {
                        suggestedProductBloc.add(ChangeTabEvent(index: index));
                      },
                      tabs: tabs
                          .map((e) => Tab(
                                text: e.brandName,
                              ))
                          .toList(),
                    );
                  },
                )),
          ),
          body: BlocBuilder<SuggestedProductBloc, SuggestedProductState>(
            builder: (context, state) {
              if (_tabController == null) {
                return Container();
              }
              if (state is ChangeTabState) {
                currentIndex = state.index;
                if (productMap[tabs[_tabController!.index].brandName] == null) {
                  suggestedProductBloc.add(GetProductEvent(brandId: tabs[state.index].brandName));
                  return CircularProgressIndicator();
                }
              }
              if (state is LoadingState) {
                return Center(child: CircularProgressIndicator());
              }

              if (state is GetProductState) {
                productMap[tabs[_tabController!.index].brandName] = state.products;
              }

              if (productMap[tabs[_tabController!.index].brandName] != null) {
                return SuggestedProductList(productMap[tabs[_tabController!.index].brandName]!);
              }
              return CircularProgressIndicator();
            },
          ),
          bottomNavigationBar: Container(child: BlocBuilder<SuggestedProductBloc, SuggestedProductState>(
            builder: (context, state) {
              return MaterialButton(
                elevation: 0,
                onPressed: !enabled
                    ? null
                    : () {
                        if (productMap.isNotEmpty) {
                          List<ProductModel> products = [];
                          productMap.forEach((key, value) {
                            if (value.isNotEmpty) {
                              products.addAll(value.where((element) => element.check).toList());
                            }
                          });



                          String id = "";
                          for (int i = 0; i < products.length; i++) {
                            if (i == products.length - 1) {
                              id += products[i].id;
                            } else {
                              id += products[i].id + ",";
                            }
                          }


                          if (id.isNotEmpty) {
                            suggestedProductBloc.add(AddProductApiEvent(id: id));
                          }
                        }
                      },
                color: ColorPrimary,
                shape: RoundedRectangleBorder(),
                disabledColor: Colors.grey,
                height: 50,
                disabledTextColor: Colors.white,
                child: Text("ADD PRODUCT"),
              );
            },
          )),
        ),
      ),
    );
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
