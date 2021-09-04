import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/product_variant.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/utility/color.dart';

class ProductVariantScreen extends StatefulWidget {
  @override
  _ProductVariantScreenState createState() => _ProductVariantScreenState();
}

class _ProductVariantScreenState extends State<ProductVariantScreen> {
  List<ProductVariantModel> variants = [];
  TextEditingController edtOption = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Add Variant",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextFormField(
              controller: edtOption,
              decoration: InputDecoration(
                  labelText: "Enter options",
                  suffixIcon: InkWell(
                    onTap: () {
                      if (edtOption.text.trim().isNotEmpty) {
                        variants.add(ProductVariantModel(option: edtOption.text.trim()));
                        edtOption.clear();
                        FocusScope.of(context).unfocus();
                        setState(() {});
                      }
                    },
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorPrimary,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        "ADD",
                        style: Theme.of(context).textTheme.caption!.merge(TextStyle(color: Colors.white)),
                      ),
                      alignment: Alignment.center,
                    ),
                  ),
                  suffixIconConstraints: BoxConstraints(maxWidth: 50, maxHeight: 30, minHeight: 10, minWidth: 10)),
            ),
            Column(
              children: List.generate(variants.length, (index) {
                return ProductVariantWidget(variants[index]);
              }),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: MaterialButton(
          onPressed: () {
            Navigator.pop(context, variants);
          },
          height: 50,
          shape: RoundedRectangleBorder(),
          color: ColorPrimary,
          child: Text("DONE"),
        ),
      ),
    );
  }
}

class ExpansionListTile extends StatefulWidget {
  final title;

  ExpansionListTile(this.title);

  @override
  _ExpansionListTileState createState() => _ExpansionListTileState();
}

class _ExpansionListTileState extends State<ExpansionListTile> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      maintainState: true,
      title: Text("${widget.title}"),
      tilePadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      childrenPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      backgroundColor: Colors.white,
      children: [
        Text("Add Image"),
        Container(
          height: 100,
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.camera),
                ),
              ),
              Container(
                width: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Container(
                        width: 80, height: 80, margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10), color: Colors.red);
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text("Add Variant"),
        TextFormField(
          decoration: InputDecoration(labelText: "Size"),
        ),
        SizedBox(
          height: 10,
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
        SizedBox(
          height: 10,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: "Stock"),
        ),
      ],
    );
  }
}

class ProductVariantWidget extends StatefulWidget {
  final ProductVariantModel variant;

  ProductVariantWidget(this.variant);

  @override
  _ProductVariantWidgetState createState() => _ProductVariantWidgetState();
}

class _ProductVariantWidgetState extends State<ProductVariantWidget> {
  StreamController<List<File>> imgController = StreamController();
  ProductVariantModel variant = ProductVariantModel();

  @override
  void initState() {
    this.variant = widget.variant;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(1)),
        margin: EdgeInsets.symmetric(vertical: 10),
        child: ExpansionTile(
          expandedAlignment: Alignment.topLeft,
          maintainState: true,
          title: Text("${widget.variant.option}"),
          tilePadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          backgroundColor: Colors.white,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.black)),
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                children: [
                  Text("Add Image"),
                  Container(
                    height: 100,
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(5)),
                          child: IconButton(
                            onPressed: () {
                              selectImage(context, widget.variant.productImages);
                            },
                            icon: Icon(Icons.linked_camera),
                          ),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width - 140,
                            child: StreamBuilder<List<File>>(
                              stream: imgController.stream,
                              initialData: [],
                              builder: (context, snap) {
                                if (snap.hasData && snap.data!.isNotEmpty) {
                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snap.data!.length,
                                    itemBuilder: (context, index) {
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
                                              widget.variant.productImages.removeAt(index);
                                              imgController.add(widget.variant.productImages);
                                            },
                                          ),
                                        )
                                      ]);
                                    },
                                  );
                                }

                                return Container();
                              },
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Add Variant"),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Size"),
                  ),
                  SizedBox(
                    height: 10,
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
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Stock"),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  selectImage(BuildContext context, List<File> productImages) async {
    try {
      XFile? image = await imagePicker.pickImage(source: ImageSource.camera);
      if (image != null) {
        print(image.path);
        List<File> images = productImages;
        images.add(File(image.path));
        imgController.add(images);
      }
    } catch (exception) {
      debugPrint("exception-->$exception");
    }
  }

  @override
  void dispose() {
    super.dispose();
    imgController.close();
  }
}
