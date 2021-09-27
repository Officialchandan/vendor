import 'package:flutter/material.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/get_categories_response.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

class SelectCategoryWidget extends StatefulWidget {
  final Function(String? categoryId) onSelect;
  SelectCategoryWidget({required this.onSelect});

  @override
  _SelectCategoryWidgetState createState() => _SelectCategoryWidgetState();
}

class _SelectCategoryWidgetState extends State<SelectCategoryWidget> {
  List<CategoryModel> categories = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextFormField(
          readOnly: true,
          onTap: () {
            widget.onSelect(null);
            // Navigator.push(context, PageTransition(child: SearchProductScreen(), type: PageTransitionType.fade));
          },
          decoration: InputDecoration(
              filled: true,
              fillColor: Color.fromRGBO(242, 242, 242, 1),
              hintText: "Search products",
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              prefixIcon: Icon(Icons.search)),
        ),
        SizedBox(
          height: 10,
        ),
        Text("Search by Category"),
        SizedBox(
          height: 10,
        ),
        FutureBuilder<List<CategoryModel>>(
          future: getCategory(),
          builder: (context, snap) {
            if (snap.hasData) {
              print(snap.data);
              if (snap.data!.isEmpty) {
                return Center(
                  child: Image(
                    image: AssetImage("assets/images/no_data.gif"),
                    fit: BoxFit.contain,
                  ),
                  // child: Text("${AppTranslations.of(context)!.text(StringConst.record_not_found)}"),
                );
              }

              return Column(
                children: List.generate(snap.data!.length, (index) {
                  return Container(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.grey.shade300, width: 1)),
                      onTap: () {
                        widget.onSelect(snap.data![index].id.toString());
                        // Navigator.push(
                        //     context,
                        //     PageTransition(
                        //         child: SearchProductScreen(
                        //           categoryId: snap.data![index].id.toString(),
                        //         ),
                        //         type: PageTransitionType.fade));
                        // widget.onTap();
                      },
                      leading: Image(
                        image: NetworkImage(snap.data![index].image!),
                        height: 30,
                        width: 30,
                        color: ColorPrimary,
                        fit: BoxFit.contain,
                      ),
                      title: Text(snap.data![index].categoryName!),
                    ),
                  );
                }),
              );
            }
            return Container();
          },
        ),
      ],
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
