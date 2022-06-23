import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/get_categories_response.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

class CategoryBottomSheet extends StatefulWidget {
  final Function(CategoryModel category) onSelect;

  CategoryBottomSheet({required this.onSelect});

  @override
  _CategoryBottomSheetState createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet> {
  List<CategoryModel> categories = [];

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 0, 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "select_category_key".tr(),
                style: TextStyle(color: ColorPrimary, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.40,
            child: FutureBuilder<List<CategoryModel>>(
              future: getCategory(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snap.hasData && snap.data!.isNotEmpty) {
                  return ListView.separated(
                      itemCount: snap.data!.length,
                      separatorBuilder: (context, index) {
                        return Divider(
                          color: Colors.grey.shade300,
                          height: 1,
                        );
                      },
                      itemBuilder: (context, index) {
                        CategoryModel category = snap.data![index];
                        return ListTile(
                          onTap: () {
                            widget.onSelect(category);
                            Navigator.pop(context);
                          },
                          leading: Image.network(
                            "${category.image}",
                            height: 35,
                            width: 35,
                            fit: BoxFit.contain,
                            color: ColorPrimary,
                          ),
                          title: Text("${category.categoryName}"),
                        );
                      });
                }
                return Center(
                  child: Text("Category not found!"),
                );
              },
            ),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "cancel_key".tr(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Future<List<CategoryModel>> getCategory() async {
    if (await Network.isConnected()) {
      GetCategoriesResponse response = await apiProvider.getAllCategories();

      if (response.success) {
        categories = response.data!;
        return categories;
      } else {
        return [];
      }
    } else {
      Utility.showToast(msg: Constant.INTERNET_ALERT_MSG);
      return [];
    }
  }
}
