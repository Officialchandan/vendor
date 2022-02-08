import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:vendor/model/vendor_profile_response.dart';

class TermsAndCondition extends StatefulWidget {
  VendorDetailData? vendorDetailData;
  TermsAndCondition({Key? key, this.vendorDetailData}) : super(key: key);

  @override
  State<TermsAndCondition> createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "t&c_with_signature".tr(),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.62,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      primary: false,
                      child: Text(
                        widget.vendorDetailData!.termsAndCondition.isNotEmpty
                            ? widget.vendorDetailData!.termsAndCondition
                            : "T&C not available",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                            imageUrl: widget
                                    .vendorDetailData!.ownerSign.isNotEmpty
                                ? widget.vendorDetailData!.ownerSign
                                : "https://blog.yorksj.ac.uk/amelia-lambert/wp-content/themes/oria/images/placeholder.png",
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
                                      child: CircularProgressIndicator(
                                          value: downloadProgress.progress),
                                    ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
