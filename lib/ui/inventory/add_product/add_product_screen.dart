import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendor/UI/inventory/add_product/bloc/add_product_state.dart';
import 'package:vendor/model/get_sub_category_response.dart';
import 'package:vendor/UI/custom_widget/app_bar.dart';
import 'package:vendor/UI/inventory/add_product/bloc/add_product_bloc.dart';
import 'package:vendor/UI/inventory/add_product/bloc/add_product_event.dart';

import 'package:vendor/UI/inventory/product_varient/product_varient_screen.dart';
import 'package:vendor/UI/inventory/select_sub_category.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/utility.dart';
import 'package:vendor/widget/UnitBottomSheet.dart';
import 'package:vendor/widget/category_bottom_sheet.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  List<File> imageList = [];
  AddProductBloc addProductBloc = AddProductBloc();
  StreamController<List<File>> imgController = StreamController();
  bool showOnline = true;
  TextEditingController edtCategory = TextEditingController();
  TextEditingController edtSubCategoryCategory = TextEditingController();
  TextEditingController edtMrp = TextEditingController();
  TextEditingController edtPurchasePrice = TextEditingController();
  TextEditingController edtSalePrice = TextEditingController();
  TextEditingController edtColor = TextEditingController();
  TextEditingController edtSize = TextEditingController();
  TextEditingController edtDescription = TextEditingController();
  TextEditingController edtName = TextEditingController();
  TextEditingController edtUnit = TextEditingController();
  String categoryId = "";
  String unitId = "";
  List<SubCategoryModel> subCategories = [];

  @override
  void dispose() {
    super.dispose();
    imgController.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddProductBloc>(
      create: (context) => addProductBloc,
      child: BlocListener<AddProductBloc, AddProductState>(
        listener: (context, state) {
          if (state is SelectImageState) {
            imageList.add(state.image);
            imgController.add(imageList);
          }
        },
        child: Scaffold(
          appBar: CustomAppBar(
            title: "Add Product",
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Add Products Image"),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(5)),
                        child: IconButton(
                          onPressed: () {
                            addProductBloc.add(SelectImageEvent(context: context));
                          },
                          icon: Icon(Icons.linked_camera),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      StreamBuilder<List<File>>(
                        stream: imgController.stream,
                        initialData: [],
                        builder: (context, snap) {
                          if (snap.hasData && snap.data!.isNotEmpty) {
                            return Row(
                              children: List.generate(snap.data!.length, (index) {
                                return Stack(children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        image: DecorationImage(
                                          image: FileImage(
                                            snap.data![index],
                                          ),
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: InkWell(
                                      child: Container(
                                          width: 25,
                                          padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(shape: BoxShape.circle, color: ColorPrimary),
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 15,
                                          )),
                                      onTap: () {
                                        imageList.removeAt(index);
                                        imgController.add(imageList);
                                      },
                                    ),
                                  )
                                ]);
                              }),
                            );
                          }

                          return Container();
                        },
                      ),
                    ],
                  ),
                ),
                BlocBuilder<AddProductBloc, AddProductState>(
                  builder: (context, state) {
                    if (state is ShowOnlineShopState) {
                      showOnline = state.online;
                    }

                    return SwitchListTile(
                      value: showOnline,
                      onChanged: (value) {
                        addProductBloc.add(ShowOnlineShopEvent(online: value));
                      },
                      title: Text("Show Online"),
                      contentPadding: EdgeInsets.all(0),
                    );
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Product name",
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  readOnly: true,
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return CategoryBottomSheet(onSelect: (category) {
                            categoryId = category.id;
                            edtCategory.text = category.categoryName!;
                          });
                        });
                  },
                  controller: edtCategory,
                  decoration: InputDecoration(
                      labelText: "Category",
                      hintText: "Select category",
                      suffixIcon: Icon(Icons.keyboard_arrow_right_sharp),
                      suffixIconConstraints: BoxConstraints(minWidth: 20, maxWidth: 21, minHeight: 20, maxHeight: 21)),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  readOnly: true,
                  controller: edtSubCategoryCategory,
                  onTap: () async {
                    var result = await Navigator.push(
                        context,
                        PageTransition(
                            child: SelectSubCategory(
                              categoryId: categoryId,
                            ),
                            type: PageTransitionType.fade));

                    if (result != null) {
                      subCategories = result as List<SubCategoryModel>;
                      String subCategory = "";
                      subCategories.forEach((element) {
                        subCategory = subCategory + element.subCatName + "\n";
                      });
                    }
                  },
                  decoration: InputDecoration(
                      hintText: "Select subcategory",
                      labelText: "Subcategory",
                      suffixIcon: Icon(Icons.keyboard_arrow_right_sharp),
                      suffixIconConstraints: BoxConstraints(minWidth: 20, maxWidth: 21, minHeight: 20, maxHeight: 21)),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "Purchase price"),
                      ),
                      flex: 3,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "MRP"),
                      ),
                      flex: 2,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "Selling price"),
                      ),
                      flex: 3,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "Stock"),
                      ),
                      flex: 2,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: edtUnit,
                        onTap: () {
                          if (categoryId.isEmpty) {
                            Utility.showToast("Please select category first.");
                            return;
                          }

                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return UnitBottomSheet(
                                    categoryId: categoryId,
                                    onSelect: (unit) {
                                      unitId = unit.id;
                                      edtUnit.text = unit.unitName;
                                    });
                              });
                        },
                        decoration: InputDecoration(
                            labelText: "Unit",
                            suffixIcon: Icon(Icons.keyboard_arrow_right_sharp),
                            suffixIconConstraints: BoxConstraints(minWidth: 20, maxWidth: 21, minHeight: 20, maxHeight: 21)),
                      ),
                      flex: 2,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Select color",
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Select size",
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Product description",
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ListTile(
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.black, width: 1)),
                  onTap: () {
                    Navigator.push(context, PageTransition(child: ProductVariantScreen(), type: PageTransitionType.bottomToTop));
                  },
                  title: Text("Add Product Variants"),
                  subtitle: Text("Color, Size etc."),
                  contentPadding: EdgeInsets.only(right: 0, left: 10),
                  trailing: Icon(Icons.keyboard_arrow_right_sharp),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            child: MaterialButton(
              onPressed: () {},
              height: 50,
              shape: RoundedRectangleBorder(),
              color: ColorPrimary,
              child: Text("ADD PRODUCT"),
            ),
          ),
        ),
      ),
    );
  }
}
