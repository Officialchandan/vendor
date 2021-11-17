import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/get_categories_response.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';
import 'package:vendor/widget/app_button.dart';

class SelectCategoriesScreen extends StatefulWidget {
  @override
  _SelectCategoriesScreenState createState() => _SelectCategoriesScreenState();
}

class _SelectCategoriesScreenState extends State<SelectCategoriesScreen> {
  StreamController<List<CategoryModel>> categoryController = StreamController();
  List<CategoryModel> categoryList = [];
  StreamController<bool> dataController = StreamController();
  StreamController<int> checkController = StreamController();
  int groupId = -1;

  @override
  void initState() {
    getCategory();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    categoryController.close();
    dataController.close();
    checkController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context, "hi");
            },
          ),
          title: AutoSizeText(
            // "${AppTranslations.of(context)!.text(StringConst.all_categories)}",
            "select_category_key".tr(),
            style: Theme.of(context).textTheme.headline6!.merge(
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            maxFontSize: 25,
            minFontSize: 15,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  // categoryBloc.add(SearchingEvent(text: ""));
                },
                icon: Icon(Icons.search_rounded))
          ],
        ),
        body: StreamBuilder<List<CategoryModel>>(
          stream: categoryController.stream,
          initialData: [],
          builder: (context, snap) {
            if (snap.hasData) {
              if (snap.data!.isEmpty) {
                dataController.add(false);
                return Center(
                  child: Image(
                    image: AssetImage("assets/images/no_search.gif"),
                    fit: BoxFit.contain,
                  ),
                  // child: Text("${AppTranslations.of(context)!.text(StringConst.record_not_found)}"),
                );
              }
              dataController.add(true);

              return ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade100),
                    child: ListTile(
                      tileColor: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onTap: () {
                        // widget.onTap();
                      },
                      leading: Radio(
                        groupValue: groupId,
                        value: snap.data![index].id,
                        onChanged: (value) {
                          print(value);
                          groupId = value as int;
                          setState(() {});
                        },
                      ),
                      title: Text(snap.data![index].categoryName!),
                    ),
                  );
                },
                itemCount: snap.data!.length,
              );
            }
            return Container();
          },
        ),
        bottomSheet: StreamBuilder<bool>(
          stream: dataController.stream,
          initialData: true,
          builder: (context, snap) {
            if (snap.hasData && snap.data!) {
              return Container(
                margin: EdgeInsets.all(10),
                child: AppButton(
                  title: "done_key".tr(),
                  width: double.infinity,
                  onPressed: () {
                    if (groupId != -1) {
                      CategoryModel categoryModel = categoryList.singleWhere(
                          (element) => element.id == groupId.toString());

                      // Navigator.pushNamed(context, Routs.VENDOR_LIST_SCREEN, arguments: categoryModel);
                    } else {
                      Utility.showToast("please_select_category_key".tr());
                    }
                  },
                ),
              );
            }
            return Container(
              width: 0,
              height: 0,
            );
          },
        ));
  }

  void getCategory() async {
    if (await Network.isConnected()) {
      GetCategoriesResponse response = await apiProvider.getAllCategories();

      if (response.success) {
        categoryList = response.data!;
      } else {
        Utility.showToast(response.message);
      }

      categoryController.add(categoryList);
    } else {
      categoryController.add(categoryList);
      Utility.showToast(Constant.INTERNET_ALERT_MSG);
      // EasyLoading.showError(Constant.INTERNET_ALERT_MSG);
    }
  }
}
