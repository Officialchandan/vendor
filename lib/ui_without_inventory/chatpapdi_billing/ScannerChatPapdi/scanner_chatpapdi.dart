import 'dart:collection';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:vendor/model/chat_papdi_module/billing_chatpapdi.dart';
import 'package:vendor/model/verify_otp.dart';

import 'package:vendor/ui/billingflow/billing/billing.dart';
import 'package:vendor/ui_without_inventory/chatpapdi_billing/ScannerChatPapdi/scanner_chatpapdi_bloc.dart';
import 'package:vendor/ui_without_inventory/chatpapdi_billing/ScannerChatPapdi/scanner_chatpapdi_event.dart';
import 'package:vendor/ui_without_inventory/chatpapdi_billing/ScannerChatPapdi/scanner_chatpapdi_state.dart';
import 'package:vendor/ui_without_inventory/home/bottom_navigation_bar.dart';
import 'package:vendor/utility/sharedpref.dart';

class Scanner extends StatefulWidget {
  final ChatPapdiData data;
  Scanner({required this.data});

  @override
  State<StatefulWidget> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  ScannerBloc scannerBloc = ScannerBloc();
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

  add() {
    return Navigator.push(
        context, MaterialPageRoute(builder: (context) => BillingScreen()));
  }

  Future<void> scanner(BuildContext context) async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["bill_id"] = widget.data.billId;
    input["vendor_id"] = widget.data.vendorId;
    input["gift_id"] = 1;
    input["qr_code"] = "brc_01";
    input["customer_id"] = widget.data.customerId;

    scannerBloc.add(GetScannerEvent(data: input));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                BottomNavigationHomeWithOutInventory()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScannerBloc>(
      create: (context) => scannerBloc,
      child: BlocListener<ScannerBloc, ScannerState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is GetScannerState) {
            Navigator.of(context).pop(result!.code);
          }
          if (state is GetScannerStateLoadingstate) {}
          if (state is IntitalScannerstate) {}
          if (state is GetScannerStateFailureState) {}
        },
        child: BlocBuilder<ScannerBloc, ScannerState>(
          builder: (context, state) {
            return Scaffold(
              body: Column(
                children: <Widget>[
                  Expanded(flex: 4, child: _buildQrView(context)),
                  Expanded(
                    flex: 1,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          if (result != null)
                            // add()
                            // Navigator.of(context).pop(result!.code)

                            Container(
                              margin: const EdgeInsets.all(8),
                              child: ElevatedButton(
                                onPressed: () async {
                                  log("message=>${result!.code}");
                                  log("data==>${widget.data}");
                                  scanner(context);
                                  Fluttertoast.showToast(
                                      msg: "${result!.code}");
                                },
                                child: const Text('Done',
                                    style: TextStyle(fontSize: 20)),
                              ),
                            )
                          // Text(
                          //   "Scann Done",
                          //   style: TextStyle(fontSize: 16),
                          // )
                          // Text(
                          //   'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}',
                          //   style: TextStyle(fontSize: 16),
                          // )
                          else
                            const Text('Scan a code'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              // Container(
                              //   margin: const EdgeInsets.all(8),
                              //   child: ElevatedButton(
                              //       onPressed: () async {
                              //         await controller?.toggleFlash();
                              //         setState(() {});
                              //       },
                              //       child: FutureBuilder(
                              //         future: controller?.getFlashStatus(),
                              //         builder: (context, snapshot) {
                              //           return Text('Flash: ${snapshot.data}');
                              //         },
                              //       )),
                              // ),
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
                                          return Text(
                                              'Camera facing ${describeEnum(snapshot.data!)}');
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
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BillingScreen()),
                                        (route) => false);
                                  },
                                  child: const Text('Skip',
                                      style: TextStyle(fontSize: 20)),
                                ),
                              ),
                            ],
                          ),
                          // Row(
                          //   children: [
                          //     Container(
                          //       margin: const EdgeInsets.all(8),
                          //       child: ElevatedButton(
                          //         onPressed: () async {
                          //           log("message=>${result!.code}");
                          //           Navigator.of(context).pop(result!.code);
                          //         },
                          //         child: const Text('Done',
                          //             style: TextStyle(fontSize: 20)),
                          //       ),
                          //     ),
                          //   ],
                          // )
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   children: <Widget>[
                          //     Container(
                          //       margin: const EdgeInsets.all(8),
                          //       child: ElevatedButton(
                          //         onPressed: () async {
                          //           await controller?.pauseCamera();
                          //         },
                          //         child: const Text('pause',
                          //             style: TextStyle(fontSize: 20)),
                          //       ),
                          //     ),
                          //     Container(
                          //       margin: const EdgeInsets.all(8),
                          //       child: ElevatedButton(
                          //         onPressed: () async {
                          //           await controller?.resumeCamera();
                          //         },
                          //         child: const Text('resume',
                          //             style: TextStyle(fontSize: 20)),
                          //       ),
                          //     )
                          //   ],
                          // ),
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
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
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
