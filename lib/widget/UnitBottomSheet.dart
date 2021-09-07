import 'package:flutter/material.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/get_unit_response.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

class UnitBottomSheet extends StatefulWidget {
  final Function(UnitModel unit) onSelect;
  final String categoryId;

  UnitBottomSheet({required this.onSelect, required this.categoryId});

  @override
  _UnitBottomSheetState createState() => _UnitBottomSheetState();
}

class _UnitBottomSheetState extends State<UnitBottomSheet> {
  List<UnitModel> units = [];

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        children: [
          Text(
            "Select Category",
            style: TextStyle(color: ColorPrimary, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.40,
            child: FutureBuilder<List<UnitModel>>(
              future: getUnit(widget.categoryId),
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
                        UnitModel unit = snap.data![index];
                        return ListTile(
                          onTap: () {
                            widget.onSelect(unit);
                            Navigator.pop(context);
                          },
                          title: Text("${unit.unitName}"),
                        );
                      });
                }
                return Center(
                  child: Text("Unit not found!"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<UnitModel>> getUnit(String categoryId) async {
    if (await Network.isConnected()) {
      GetUnitResponse response = await apiProvider.getUnitsByCategory(categoryId);

      if (response.success) {
        units = response.data!;
        return units;
      } else {
        return [];
      }
    } else {
      Utility.showToast(Constant.INTERNET_ALERT_MSG);
      return [];
    }
  }
}
