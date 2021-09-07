import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:vendor/model/add_sub_category_response.dart';
import 'package:vendor/model/get_sub_category_response.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';
import 'package:vendor/widget/app_button.dart';

import '../../main.dart';

class SelectSubCategory extends StatefulWidget {
  final String categoryId;

  SelectSubCategory({required this.categoryId});

  @override
  _SelectSubCategoryState createState() => _SelectSubCategoryState();
}

class _SelectSubCategoryState extends State<SelectSubCategory> {
  List<SubCategoryModel> subCategoryList = [];

  StreamController<List<SubCategoryModel>> controller = StreamController();

  @override
  void initState() {
    getSubCategory(widget.categoryId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Sub Category"),
          actions: [
            TextButton(
                onPressed: () {
                  List<SubCategoryModel> subCategory = subCategoryList
                      .where((element) => element.check)
                      .toList();
                  Navigator.pop(context, subCategory);
                },
                child: Text(
                  "DONE",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: StreamBuilder<List<SubCategoryModel>>(
          stream: controller.stream,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snap.hasData && snap.data!.isNotEmpty) {
              return ListView.builder(
                  itemCount: snap.data!.length,
                  itemBuilder: (context, index) {
                    SubCategoryModel subCategory = snap.data![index];
                    return ListTile(
                      leading: Checkbox(
                        onChanged: (check) {
                          subCategoryList[index].check = check!;
                          controller.add(subCategoryList);
                        },
                        value: subCategory.check,
                      ),
                      title: Text("${subCategory.subCatName}"),
                    );
                  });
            }
            return Center(
              child: Text("Unit not found!"),
            );
          },
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(10),
          child: MaterialButton(
            onPressed: () {},
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: ColorPrimary, width: 1)),
            height: 45,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: ColorPrimary,
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Add new Subcategory",
                  style: TextStyle(color: ColorPrimary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getSubCategory(String categoryId) async {
    if (await Network.isConnected()) {
      GetSubCategoryResponse response =
          await apiProvider.getSubCategory(categoryId);

      if (response.success) {
        subCategoryList = response.data!;
        controller.add(subCategoryList);
      } else {
        controller.add([]);
      }
    } else {
      controller.add([]);
      Utility.showToast(Constant.INTERNET_ALERT_MSG);
    }
  }
}

class AddCategoryBottomSheet extends StatefulWidget {
  final Function(SubCategoryModel subCategoryModel) onAdd;

  AddCategoryBottomSheet({required this.onAdd});

  @override
  _AddCategoryBottomSheetState createState() => _AddCategoryBottomSheetState();
}

class _AddCategoryBottomSheetState extends State<AddCategoryBottomSheet> {
  TextEditingController editText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Add new subcategory"),
        TextFormField(
          controller: editText,
          decoration: InputDecoration(hintText: "Subcategory name"),
        ),
        AppButton(
          title: "ADD",
          onPressed: () {},
        )
      ],
    );
  }

  void addSubCategory(String categoryId) async {
    if (await Network.isConnected()) {
      Map input = HashMap<String, dynamic>();

      AddSubCategoryResponse response = await apiProvider.addSubCategory(input);

      //   if (response.success) {
      //     subCategoryList = response.data!;
      //     controller.add(subCategoryList);
      //   } else {
      //     controller.add([]);
      //   }
      // } else {
      //   controller.add([]);
      //   Utility.showToast(Constant.INTERNET_ALERT_MSG);
    }
  }
}
