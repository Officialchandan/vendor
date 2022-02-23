import 'dart:async';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/product_variant_response.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

class VariantTypeBottomSheet extends StatefulWidget {
  final String categoryId;
  final List<VariantType> selectedVariants;
  final Function(List<VariantType>) onSelect;

  VariantTypeBottomSheet(
      {required this.categoryId,
      required this.onSelect,
      required this.selectedVariants});

  @override
  _VariantTypeBottomSheetState createState() => _VariantTypeBottomSheetState();
}

class _VariantTypeBottomSheetState extends State<VariantTypeBottomSheet> {
  StreamController<List<VariantType>> controller = StreamController();
  List<VariantType> variantList = [];

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  void initState() {
    getVariant();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            title: Text(
              "select_variant_options_key".tr(),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.40,
            child: StreamBuilder<List<VariantType>>(
              stream: controller.stream,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snap.hasData && snap.data!.isNotEmpty) {
                  return ListView.separated(
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemCount: snap.data!.length,
                      itemBuilder: (context, index) {
                        VariantType variant = snap.data![index];
                        return ListTile(
                          horizontalTitleGap: 8,
                          leading: Checkbox(
                            activeColor: ColorPrimary,
                            onChanged: (check) {
                              variantList[index].checked = check!;
                              controller.add(variantList);
                            },
                            value: variant.checked,
                          ),
                          title: Text(
                            "${variant.variantName}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      });
                }
                return Center(
                  child: Text("subcategories_not_found_key!".tr()),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "cancel_key".tr(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )),
              TextButton(
                  onPressed: () {
                    List<VariantType> variants = variantList
                        .where((element) => element.checked)
                        .toList();
                    Navigator.pop(context);
                    widget.onSelect(variants);
                  },
                  child: Text(
                    "done_key".tr(),
                    style: TextStyle(
                        color: ColorPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )),
            ],
          )
        ],
      ),
    );
  }

  void getVariant() async {
    if (await Network.isConnected()) {
      ProductVariantResponse response =
          await apiProvider.getProductVariantType(widget.categoryId);

      if (response.success) {
        variantList = response.data!;

        for (VariantType v in widget.selectedVariants) {
          variantList.singleWhere((element) => element.id == v.id).checked =
              true;
        }

        controller.add(variantList);
      } else {
        controller.add(variantList);
      }
    } else {
      Utility.showToast(Constant.INTERNET_ALERT_MSG);
      controller.add(variantList);
    }
  }
}
