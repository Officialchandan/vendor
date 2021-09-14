import 'dart:async';

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
          Text("Select variant options"),
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
            ],
          )
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
      Utility.showToast(Constant.INTERNET_ALERT_MSG);
      controller.add(colorList);
    }
  }
}
