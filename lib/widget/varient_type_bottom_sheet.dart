import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/product_variant_response.dart';
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
        children: [
          Text("Select variant options"),
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
                  return ListView.builder(
                      itemCount: snap.data!.length,
                      itemBuilder: (context, index) {
                        VariantType variant = snap.data![index];
                        return ListTile(
                          leading: Checkbox(
                            onChanged: (check) {
                              variantList[index].checked = check!;
                              controller.add(variantList);
                            },
                            value: variant.checked,
                          ),
                          title: Text("${variant.variantName}"),
                        );
                      });
                }
                return Center(
                  child: Text("Subcategories not found!"),
                );
              },
            ),
          ),
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () {
                    List<VariantType> variants = variantList
                        .where((element) => element.checked)
                        .toList();
                    Navigator.pop(context);
                    widget.onSelect(variants);
                  },
                  child: Text("Done")),
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
