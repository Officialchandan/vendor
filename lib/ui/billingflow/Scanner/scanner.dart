import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:vendor/model/verify_otp.dart';
import 'package:vendor/ui/billingflow/Scanner/scanner_bloc.dart';
import 'package:vendor/ui/billingflow/Scanner/scanner_event.dart';
import 'package:vendor/ui/billingflow/Scanner/scanner_state.dart';
import 'package:vendor/ui/home/bottom_navigation_home.dart';
import 'package:vendor/utility/utility.dart';
import 'package:vendor/widget/gift_scan_successfull.dart';
import 'package:vendor/widget/retry_popup.dart';

class Scanner extends StatefulWidget {
  final VerifyEarningCoinsOtpData data;
  Scanner({required this.data});

  @override
  State<StatefulWidget> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  ScannerBloc scannerBloc = ScannerBloc();
  StreamController<QRViewController> imgController = StreamController();
  bool api = true;
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> scanner(BuildContext context) async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["order_id"] = widget.data.orderId;
    input["vendor_id"] = widget.data.vendorId;
    input["gift_id"] = 1;
    input["qr_code"] = result!.code;
    input["customer_id"] = widget.data.customerId;
    api = false;
    scannerBloc.add(GetScannerEvent(data: input));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return BlocProvider<ScannerBloc>(
      create: (context) => scannerBloc,
      child: BlocListener<ScannerBloc, ScannerState>(
        listener: (context, state) {
          log("state-->$state");
          // TODO: implement listener
          if (state is GetScannerState) {
            // Navigator.of(context).pop(result!.code);
            GiftScanDialouge.displayGiftScanDialouge(context, 1);
            Utility.showToast(msg: state.message);
          }
          if (state is GetScannerStateLoadingstate) {}
          if (state is IntitalScannerstate) {}
          if (state is GetScannerStateFailureState) {
            RetryDialouge.displayRetryDialouge(context).then((value) {
              api = value;
              log("==>api$api");
            });
            Utility.showToast(msg: state.message);
            Timer(Duration(seconds: 3), () => api = true);
          }
        },
        child: BlocBuilder<ScannerBloc, ScannerState>(
          builder: (context, state) {
            return Scaffold(
              body: Column(
                children: <Widget>[
                  Container(height: height * 0.90, child: _buildQrView(context)),
                  Container(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          // if (result != null)
                          //   Container(
                          //     margin: const EdgeInsets.all(8),
                          //     child: ElevatedButton(
                          //       onPressed: () async {
                          //         log("message=>${result!.code}");
                          //         log("data==>${widget.data}");
                          //         scanner(context);
                          //       },
                          //       child: const Text('Done', style: TextStyle(fontSize: 20)),
                          //     ),
                          //   )
                          // else
                          //   const Text('Scan a code'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.all(8),
                                child: ElevatedButton(
                                    onPressed: () async {
                                      await controller?.flipCamera();
                                      setState(() {});
                                    },
                                    child: FutureBuilder(
                                      future: controller?.getCameraInfo(),
                                      builder: (context, snapshot) {
                                        if (snapshot.data != null) {
                                          return Icon(Icons.flip_camera_android_rounded);
                                        } else {
                                          return const Text('loading');
                                        }
                                      },
                                    )),
                              ),
                              Container(
                                margin: const EdgeInsets.all(8),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    // CoinDialog.displayCoinDialog(context);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        PageTransition(child: BottomNavigationHome(), type: PageTransitionType.fade),
                                        ModalRoute.withName("/"));
                                  },
                                  child: const Text('Skip', style: TextStyle(fontSize: 20)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea =
        (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 200.0 : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red, borderRadius: 10, borderLength: 30, borderWidth: 10, cutOutSize: scanArea),
      cameraFacing: CameraFacing.front,
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.flipCamera();
    controller.scannedDataStream.listen((scanData) {
      Future.delayed(Duration(seconds: 1), () {
        if (api == true) {
          result = scanData;
          scanner(context);
        }
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
