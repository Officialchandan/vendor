import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/get_categories_response.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/ui/inventory/view_product/view_product.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';
import 'package:vendor/widget/show_catagories_widget.dart';

class ViewCategoryScreen extends StatefulWidget {
  @override
  _ViewCategoryScreenState createState() => _ViewCategoryScreenState();
}

class _ViewCategoryScreenState extends State<ViewCategoryScreen> {
  List<CategoryModel> categories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "View_Product_key".tr(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: SelectCategoryWidget(
          onSelect: (String? categoryId) {
            Navigator.push(
                context,
                PageTransition(
                    child: ViewProductScreen(
                      categoryId: categoryId,
                    ),
                    type: PageTransitionType.fade));
          },
        ),
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
        Utility.showToast(response.message);
        return [];
      }
    } else {
      Utility.showToast(Constant.INTERNET_ALERT_MSG);
      return [];
      // EasyLoading.showError(Constant.INTERNET_ALERT_MSG);
    }
  }
}
