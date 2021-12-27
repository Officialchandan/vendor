import 'dart:developer';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:vendor/api/api_provider.dart';
import 'package:vendor/model/daily_earning.dart';
import 'package:vendor/model/daily_sale_amount.dart';
import 'package:vendor/model/daily_walkin.dart';
import 'package:vendor/model/get_categories_response.dart';
import 'package:vendor/model/hourly_earning.dart';
import 'package:vendor/model/hourly_sale_amount.dart';
import 'package:vendor/model/hourly_walkin.dart';
import 'package:vendor/model/monthly_earning.dart';
import 'package:vendor/model/monthly_sale_amount.dart';
import 'package:vendor/model/monthly_walkin.dart';
import 'package:vendor/model/product_model.dart';
import 'package:vendor/ui/performance_tracker/report/product_list_screen.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/utility.dart';
import 'package:vendor/widget/category_bottom_sheet.dart';
import 'package:vendor/widget/show_catagories_widget.dart';

DateRangePickerController dateRangePickerController =
    DateRangePickerController();

final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();

class BottomWidget extends StatefulWidget {
  final int index, screenindex;
  final Function(String? categoryid, String? listSelected, String? date)
      onSelect;
  BottomWidget(
      {Key? key,
      required this.index,
      required this.screenindex,
      required this.onSelect})
      : super(key: key);

  @override
  _BottomWidgetState createState() => _BottomWidgetState();
}

class _BottomWidgetState extends State<BottomWidget> {
  GetCategoriesResponse? result;
  CategoryModel? categoryModel;
  String productIndex = "";
  List<ProductModel> productList = [];
  TextEditingController edtCategory = TextEditingController();
  TextEditingController edtProducts = TextEditingController();
  TextEditingController edtDate = TextEditingController();
  String selectedDate = '';
  HourlySaleAmountResponse? resultHourlySale;
  DailySellAmountResponse? resultDailySale;
  MonthlySellAmountResponse? resultMonthlySale;

  HourlyEarningAmountResponse? resultHourlyEarning;
  DailyEarningAmountResponse? resultDailyEarning;
  MonthlyEarningAmountResponse? resultMonthlyEarning;

  HourlyWalkinAmountResponse? resultHourlyWalkin;
  DailyWalkinAmountResponse? resultDailyWalkin;
  MonthlyWalkinAmountResponse? resultMonthlyWalkin;

  // final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();
  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      child: result == null
          ? Center(child: CircularProgressIndicator(color: ColorPrimary))
          : Column(
              children: [
                TextFormField(
                  controller: edtCategory,
                  onTap: () {
                    selectCategory(context);
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                      hintText: "Choose_category_key".tr(),
                      suffixIcon: Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: ColorPrimary,
                      ),
                      border: InputBorder.none,
                      suffixIconConstraints:
                          BoxConstraints(maxWidth: 20, maxHeight: 20)),
                ),
                Divider(
                  color: Colors.black26,
                  thickness: 2,
                ),
                widget.index == 0 || widget.index == 2
                    ? Text("")
                    : TextFormField(
                        controller: edtProducts,
                        onTap: () {
                          selectProduct(context);
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                            hintText: "choose_product_key".tr(),
                            border: InputBorder.none,
                            suffixIcon: Icon(
                              Icons.arrow_forward_ios_sharp,
                              color: ColorPrimary,
                            ),
                            suffixIconConstraints:
                                BoxConstraints(maxWidth: 20, maxHeight: 20)),
                      ),
                widget.index == 0 || widget.index == 2
                    ? Text("")
                    : Divider(
                        color: Colors.black26,
                        thickness: 2,
                      ),
                widget.index == 0
                    ? Text("")
                    : TextFormField(
                        controller: edtDate,
                        onTap: () {
                          calendr(context);
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: "Select date".tr(),
                          border: InputBorder.none,
                        ),
                      ),
                widget.index == 0
                    ? Text("")
                    : Divider(
                        color: Colors.black26,
                        thickness: 2,
                      ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (widget.screenindex == 1) {
                          callingapiSale(widget.index);
                        } else if (widget.screenindex == 2) {
                          callingapiEarning(widget.index);
                        } else if (widget.screenindex == 3) {
                          callingapiWalkin(widget.index);
                        }
                      },
                      child: Text(
                        "Apply",
                        style: TextStyle(
                            color: ColorPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    )
                  ],
                ),
              ],
            ),
    );
  }

  callingapiSale(int index) async {
    // categoryModel == null ? "" : categoryModel!.id;
    if (widget.index == 0) {
      resultHourlySale = (await ApiProvider()
          .getHourlySaleAmount(categoryModel == null ? "" : categoryModel!.id));
      log('===>getHourlySaleAmount${resultHourlySale!.data}');
      widget.onSelect(categoryModel == null ? "" : categoryModel!.id, "", "");
      Navigator.pop(context, categoryModel!.id);
      // return resultHourlySale!.data!;
    } else if (widget.index == 1) {
      resultDailySale = await ApiProvider().getDailySaleAmount("", "", "");
      log('${resultDailySale!.data}');

      widget.onSelect(
          categoryModel == null ? "" : categoryModel!.id, productIndex, "");
      Navigator.pop(context);
      // return resultDailySale!.data!;
    } else if (widget.index == 2) {
      resultMonthlySale = await ApiProvider().getMonthlySaleAmount("", "", "");
      log('${resultMonthlySale!.data}');
      widget.onSelect(
          categoryModel == null ? "" : categoryModel!.id, "", selectedDate);
      Navigator.pop(context);
      //return resultMonthlySale!.data!;
    }
  }

  callingapiEarning(int index) async {
    if (widget.index == 0) {
      resultHourlyEarning = (await ApiProvider().getHourlyEarningAmount());
      log('${resultHourlyEarning!.data}');
      widget.onSelect(categoryModel == null ? "" : categoryModel!.id,
          productIndex, selectedDate);
      Navigator.pop(context);
      // return resultHourlyEarning!.data!;
    } else if (widget.index == 1) {
      resultDailyEarning = await ApiProvider().getDailyEarningAmount();
      log('${resultDailyEarning!.data}');
      widget.onSelect(categoryModel == null ? "" : categoryModel!.id,
          productIndex, selectedDate);
      Navigator.pop(context);
      //return resultDailyEarning!.data!;
    } else if (widget.index == 2) {
      resultMonthlyEarning = await ApiProvider().getMonthlyEarningAmount();
      log('${resultMonthlyEarning!.data}');
      widget.onSelect(categoryModel == null ? "" : categoryModel!.id,
          productIndex, selectedDate);
      Navigator.pop(context);
      // return resultMonthlyEarning!.data!;
    }
  }

  callingapiWalkin(int index) async {
    if (widget.index == 0) {
      resultHourlyWalkin = (await ApiProvider().getHourlyWalkinAmount(""));
      log('${resultHourlyWalkin!.data}');
      widget.onSelect(categoryModel == null ? "" : categoryModel!.id,
          productIndex, selectedDate);
      Navigator.pop(context);
      // return resultHourlyWalkin!.data!;
    } else if (widget.index == 1) {
      resultDailyWalkin = await ApiProvider().getDailyWalkinAmount("", "", "");
      log('${resultDailyWalkin!.data}');
      widget.onSelect(categoryModel == null ? "" : categoryModel!.id,
          productIndex, selectedDate);
      Navigator.pop(context);
      // return resultDailyWalkin!.data!;
    } else if (widget.index == 2) {
      resultMonthlyWalkin = await ApiProvider().getMonthlyWalkinAmount();
      log('${resultMonthlyWalkin!.data}');
      widget.onSelect(categoryModel == null ? "" : categoryModel!.id,
          productIndex, selectedDate);
      Navigator.pop(context);
      // return resultMonthlyWalkin!.data!;
    }
  }

  // Future<Map<String, String>> getDhabasHourly() async {
  //   resultHourly = (await ApiProvider().getHourlySaleAmount());
  //   log('${resultHourly!.data}');
  //   //resultHourlyMap = resultHourly!.data!;
  //   //for (var i = 0; i < resultHourly!.data!.length; i++) {
  //   demo = resultHourly!.data!.keys.toList();
  //   //}

  //   return resultHourly!.data!;
  // }

  getCategories() async {
    result = await ApiProvider().getCategoryByVendorId();
    log("$result");
    CategoryModel? data;
    result!.data!.forEach((element) {
      data = element;
      // result!.data!.remove(element);
      // subcatlist.add(SubCat(element));
    });
    if (data != null) {
      result!.data!.remove(data);
    }
    setState(() {});
    // return result!.data!;
  }

  void calendr(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Container(
              height: 300,
              child: SfDateRangePicker(
                controller: dateRangePickerController,
                maxDate: DateTime.now(),
                minDate: DateTime(2000),
                enablePastDates: true,
                monthCellStyle: DateRangePickerMonthCellStyle(
                    weekendTextStyle: TextStyle(color: Colors.grey.shade300),
                    disabledDatesTextStyle:
                        TextStyle(color: Colors.grey.shade300)),
                monthViewSettings: DateRangePickerMonthViewSettings(
                  enableSwipeSelection: true,
                  showTrailingAndLeadingDates: true,
                  firstDayOfWeek: 1,
                  weekendDays: [],
                  // showWeekNumber: true
                ),
                allowViewNavigation: true,
                todayHighlightColor: Colors.grey.shade300,
                headerStyle: DateRangePickerHeaderStyle(
                  textStyle: TextStyle(color: ColorPrimary),
                ),
                yearCellStyle: DateRangePickerYearCellStyle(
                    textStyle: TextStyle(color: Colors.black)),
                showNavigationArrow: true,
                backgroundColor: Colors.white,
                selectionMode: DateRangePickerSelectionMode.single,
                endRangeSelectionColor: ColorPrimary,
                startRangeSelectionColor: ColorPrimary,
                rangeSelectionColor: Colors.blue.shade50,
                showActionButtons: true,
                onSubmit: (v) {
                  log("$v");
                  DateTime d = v as DateTime;

                  debugPrint("weekday--->${d.weekday}");

                  selectedDate = Utility.getFormatDate(v);
                  log("====>$selectedDate");
                  edtDate.text = selectedDate;
                  Navigator.pop(context);
                },
                onCancel: () {
                  Navigator.pop(context);
                },
                //onSelectionChanged: _onSelectionChanged
                //)
              ),
            ),
          );
        });
  }

  // void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
  //   print(args.value);
  //   print(args);
  //   setState(() {
  //     if (args.value is DateTime) {
  //       DateTime d = args.value as DateTime;

  //       debugPrint("weekday--->${d.weekday}");

  //       selectedDate = Utility.getFormatDate(args.value);
  //       log("$selectedDate");

  //       // code to disable sunday
  //       // if (d.weekday == 7) {
  //       //   dateRangePickerController.selectedDate = DateTime.parse(selectedDate);
  //       // } else {
  //       //   dateRangePickerController.selectedDate = d;
  //       //   selectedDate = Utility.getFormatDate(args.value);
  //       // }
  //     }

  //     print("_selectedDate$selectedDate");
  //   });
  // }

  void selectProduct(BuildContext context) async {
    productList = await Navigator.push(
        context,
        PageTransition(
            child: ProductListScreen(
              categoryId: categoryModel == null ? "" : categoryModel!.id,
            ),
            type: PageTransitionType.fade));

    String text = "";

    for (int i = 0; i < productList.length; i++) {
      if (i == productList.length - 1) {
        text += productList[i].productName;
        productIndex += productList[i].id;
      } else {
        text += productList[i].productName + ",";
        productIndex += productList[i].id + ",";
      }
    }

    edtProducts.text = text;
    log("===>$productIndex");
    print("selected product->$productList");
  }

  void selectCategory(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: CategoryBottomSheet(
              onSelect: (CategoryModel option) {
                edtCategory.text = option.categoryName!;

                log("${edtCategory.text}");

                categoryModel = option;

                log("${categoryModel!.id}");
              },
            ),
          );
        });
  }
//   showAlertList() {
//     return Container(
//         //height: MediaQuery.of(context).size.height * 0.060,
//         child:
//             //             // result == null
//             //             //     ? Center(child: CircularProgressIndicator())
//             //             //     :
//             //             // GestureDetector(
//             //             //     onTap: () {
//             //             //       FocusScopeNode currentFocus =
//             //             //           FocusScope.of(context);
//             //             //       if (!currentFocus.hasPrimaryFocus) {
//             //             //         currentFocus.unfocus();
//             //             //       }
//             //             //     },
//             //             //     child:
//             Container(
//       // height: MediaQuery.of(context).size.height * 0.060,
//       child: MultiSelectDialogField<CategoryModel?>(
//         buttonIcon: Icon(
//           Icons.keyboard_arrow_down,
//           color: Colors.transparent,
//           size: 4,
//         ),
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//         ),

//         key: _multiSelectKey,
//         // initialChildSize: 0.7,
//         // maxChildSize: 0.95,
//         title: GestureDetector(
//           onTap: () {
//             FocusManager.instance.primaryFocus?.unfocus();
//             Navigator.pop(context);
//           },
//           child: Text(
//             'Other categories',
//           ),
//         ),
//         buttonText: Text(
//           placeholderText,
//           overflow: TextOverflow.ellipsis,
//         ),
//         searchTextStyle: TextStyle(
//             color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
//         cancelText: Text('Cancel',
//             style: TextStyle(
//                 color: Color(0xff6657f4),
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600)),
//         confirmText: Text('Ok',
//             style: TextStyle(
//                 color: Color(0xff6657f4),
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600)),
//         items: result!.data!
//             .map((category) => MultiSelectItem<CategoryModel>(
//                 category, category.categoryName!))
//             .toList(),
//         searchable: true,
//         initialValue: subcatlist.map((e) => e.subCat).toList(),

//         validator: (values) {
//           if (values == null || values.isEmpty) {
//             return "";
//           }
//           List<String> names = values.map((e) => e!.categoryName!).toList();

//           if (names.contains("Frog")) {
//             return "Frogs are weird!";
//           }
//           return null;
//         },
//         onConfirm: (values) {
//           // SystemChannels.textInput.invokeMethod('TextInput.hide');
//           // SystemChannels.textInput
//           //     .invokeMethod('TextInput.hide');
//           FocusScopeNode currentFocus = FocusScope.of(context);
//           if (!currentFocus.hasPrimaryFocus) {
//             currentFocus.unfocus();
//           }
//           setState(() {
//             _selectedCategory3 = values;
//             placeholderText = "";
//             subcatlist.clear();
//             if (values.length == 0) {
//               placeholderText = "Choose Category";
//             } else {
//               for (int i = 0; i < values.length; i++) {
//                 if (i == values.length - 1) {
//                   placeholderText = "Choose Category";
//                   arr = arr + values[i]!.id.toString();
//                   log("$arr");
//                 } else {
//                   // placeholderText = placeholderText +
//                   //     values[i]!.categoryName +
//                   //     ", ";
//                   arr = arr + (values[i]!.id.toString()) + ",";
//                   log("==>$arr");
//                 }
//                 subcatlist.add(SubCat(values[i]!));
//               }
//             }
//           });
//           _multiSelectKey.currentState!.validate();
//         },
//         chipDisplay: MultiSelectChipDisplay(
//           onTap: (item) {
//             FocusScopeNode currentFocus = FocusScope.of(context);
//             if (!currentFocus.hasPrimaryFocus) {
//               currentFocus.unfocus();
//             }
//             setState(() {
//               _selectedCategory3.remove(item);
//               log("dddd ${item}");
//             });
//             _multiSelectKey.currentState!.validate();
//           },
//         )..disabled = true,
//         //  );
//         // }
//       ),
//     ));
//     //),
//     //   );
//     // });
//   }
}

class SubCat {
  TextEditingController subController = TextEditingController();
  // String hinttext = "";
  // String text = "";
  CategoryModel subCat;
  SubCat(this.subCat);
}
