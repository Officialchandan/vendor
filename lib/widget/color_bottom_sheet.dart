import 'dart:async';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/get_colors_response.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

class SelectColorBottomSheet extends StatefulWidget {
  final Function(ColorModel color) onSelect;

  SelectColorBottomSheet({required this.onSelect});

  @override
  _SelectColorBottomSheetState createState() => _SelectColorBottomSheetState();
}

class _SelectColorBottomSheetState extends State<SelectColorBottomSheet> {
  StreamController<List<ColorModel>> controller = StreamController();
  List<ColorModel> colorList = [];

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  void initState() {
    getColors();
    super.initState();
  }

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
                  "select_variant_options_key".tr(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.40,
            child: StreamBuilder<List<ColorModel>>(
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
                        ColorModel color = snap.data![index];
                        String mColor = color.colorCode.replaceAll('#', '0xff');
                        return ListTile(
                          onTap: () {
                            widget.onSelect(color);
                            Navigator.pop(context);
                          },
                          title: Text("${color.colorName}"),
                          trailing: Container(
                            height: 30,
                            width: 30,
                            color: Color(int.parse(mColor)),
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
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Center(
                child: Text(
                  "cancel_key".tr(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ))
        ],
      ),
    );
  }

  void getColors() async {
    if (await Network.isConnected()) {
      GetColorsResponse response = await apiProvider.getColors();

      if (response.success) {
        colorList = response.data!;
        controller.add(colorList);
      } else {
        controller.add(colorList);
      }
    } else {
      Utility.showToast(msg: Constant.INTERNET_ALERT_MSG);
      controller.add(colorList);
    }
  }
}
