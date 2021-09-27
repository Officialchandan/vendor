import 'package:flutter/foundation.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/product_by_category_response.dart';
import 'package:vendor/model/product_model.dart';
import 'package:vendor/utility/utility.dart';

class SuggestedProductProvider extends ChangeNotifier {
  List<ProductModel> suggestedProducts = [];

  getSuggestedProduct(String categoryId) async {
    ProductByCategoryResponse response = await apiProvider.getSuggestedProduct(categoryId);

    if (response.success) {
      suggestedProducts = response.data!;

      notifyListeners();
    } else {
      Utility.showToast(response.message);
    }
  }
}
