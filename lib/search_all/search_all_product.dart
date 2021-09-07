import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vendor/utility/color.dart';

class SearchAllProduct extends StatefulWidget {
  SearchAllProduct({Key? key}) : super(key: key);

  @override
  _SearchAllProductState createState() => _SearchAllProductState();
}

class _SearchAllProductState extends State<SearchAllProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: Icon(Icons.arrow_back_ios)),
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              height: 100,
              margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 30),
                    child: ListTile(
                      minLeadingWidth: 20,

                      // leading: CachedNetworkImage(
                      //   imageUrl:
                      //       "https://www.google.com/search?q=goku+images&rlz=1C5CHFA_enIN909IN909&tbm=isch&source=iu&ictx=1&fir=e-jwT3vV02EiEM%252CIWe1bmC5ENflZM%252C_&vet=1&usg=AI4_-kTkJtqzLLiAiAfYbNS_LFnQRk0-Ew&sa=X&ved=2ahUKEwi_kZbGturyAhU-H7cAHSIgAy8Q9QF6BAgYEAE#imgrc=e-jwT3vV02EiEM",
                      //   imageBuilder: (context, imageProvider) {
                      //     return Container(
                      //       padding: EdgeInsets.all(5),
                      //       height: 30,
                      //       width: 30,
                      //       decoration: BoxDecoration(
                      //         color: Colors.grey.shade300,
                      //       ),
                      //       child: Image(
                      //           image: imageProvider,
                      //           //color: ColorPrimary,
                      //           height: 20,
                      //           width: 20,
                      //           //colorBlendMode: BlendMode.clear,
                      //           fit: BoxFit.contain),
                      //     );
                      //   },
                      //   progressIndicatorBuilder:
                      //       (context, url, downloadProgress) => Icon(
                      //     Icons.image,
                      //     color: ColorPrimary,
                      //   ),
                      //   errorWidget: (context, url, error) => Icon(Icons.error),
                      // ),
                      // Image.network('${result!.data![index].image}', width: 20),
                      title: Container(
                        transform: Matrix4.translationValues(0, -2, 0),
                        child: Text(
                          "yha lgana hai",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      // trailing: ButtonTheme(
                      //   minWidth: 80,
                      //   height: 32,
                      //   // ignore: deprecated_member_use
                      //   child: RaisedButton(
                      //     padding: EdgeInsets.all(0),
                      //     color: Color.fromRGBO(102, 87, 244, 1),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(7),
                      //     ),
                      //     onPressed: () async {
                      //       FocusScope.of(context).unfocus();
                      //       //int id;
                      //       // if (_tap == true) {
                      //       //   _tap = false;
                      //       //   getVendorId(
                      //       //       category[index].id, category[index].categoryName);
                      //       // }
                      //     },
                      //     child: Text(
                      //       "See Category",
                      //       style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 12,
                      //           fontWeight: FontWeight.w600),
                      //     ),
                      //   ),
                      //  ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left: 0,
                    child: Container(
                      height: 60,
                      width: 60,
                      child: Image.asset("assets/images/f3-a.png"),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
