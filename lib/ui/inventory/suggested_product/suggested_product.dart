import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/model/get_categories_response.dart';
import 'package:vendor/model/product_model.dart';
import 'package:vendor/ui/inventory/suggested_product/bloc/suggested_product_bloc.dart';
import 'package:vendor/ui/inventory/suggested_product/bloc/suggested_product_event.dart';
import 'package:vendor/ui/inventory/suggested_product/bloc/suggested_product_state.dart';
import 'package:vendor/ui/inventory/suggested_product/suggested_product_list.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/utility.dart';
import 'package:vendor/widget/progress_indecator.dart';
import 'package:vendor/widget/progress_indecator.dart';

class SuggestedProductScreen extends StatefulWidget {
  @override
  _SuggestedProductScreenState createState() => _SuggestedProductScreenState();
}

class _SuggestedProductScreenState extends State<SuggestedProductScreen> with TickerProviderStateMixin {
  List<CategoryModel> tabs = [];
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
            productMap[tabs[_tabController!.index].categoryName!]![state.index].check = state.check;
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
            Utility.showToast(msg: state.message);
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("add_suggested_product_key".tr()),
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(54),
                child: BlocBuilder<SuggestedProductBloc, SuggestedProductState>(
                  builder: (context, state) {
                    if (state is SuggestedProductInitialState) {
                      suggestedProductBloc.add(GetCategoriesEvent());
                    }
                    if (state is GetCategoryState) {
                      tabs = state.categories;
                      _tabController = TabController(length: tabs.length, vsync: this);
                      suggestedProductBloc.add(GetProductEvent(categoryId: tabs[0].id));
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
                                text: e.categoryName!,
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
                if (productMap[tabs[_tabController!.index].categoryName!] == null) {
                  suggestedProductBloc.add(GetProductEvent(categoryId: tabs[state.index].id));
                  return CircularLoader();
                }
              }
              if (state is LoadingState) {
                return Center(child: CircularLoader());
              }
              if (state is GetProductFailureState) {
                return Center(child: Text(state.message));
              }

              if (state is GetProductState) {
                productMap[tabs[_tabController!.index].categoryName!] = state.products;
              }

              if (productMap[tabs[_tabController!.index].categoryName!] != null) {
                return SuggestedProductList(productMap[tabs[_tabController!.index].categoryName!]!);
              }
              return CircularLoader();
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
                child: Text("add_product_key".tr()),
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
