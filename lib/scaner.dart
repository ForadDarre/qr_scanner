import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_scanner/result_page.dart';
import 'constants.dart' as constants;

class Scaner extends StatefulWidget {
  const Scaner({Key? key}) : super(key: key);

  @override
  _Scaner createState() => _Scaner();
}

class _Scaner extends State<Scaner> {
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      //controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(constants.mainColor),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              cameraFacing: CameraFacing.back,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderRadius: 10,
                borderWidth: 5,
                borderColor: const Color(constants.whiteColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void closeResult() {
    setState(() {
      result = null;
      controller?.resumeCamera();
    });
  }

  Future<bool> _onBackPressed() {
    closeResult();
    return Future<bool>.value(true);
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });

      if (Uri.parse(scanData.code!).isAbsolute) {
        controller.pauseCamera();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                ResultPage(item: scanData.code!, callback: () => closeResult()),
          ),
        );
      } else if (scanData.code != null) {
        controller.pauseCamera();
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return WillPopScope(
                  onWillPop: _onBackPressed,
                  child: AlertDialog(
                    title: const Text(
                      'Scanning',
                      style: TextStyle(color: Color(constants.whiteColor)),
                    ),
                    backgroundColor: const Color(constants.mainColor),
                    content: Text(
                      scanData.code!,
                      style:
                          const TextStyle(color: Color(constants.whiteColor)),
                    ),
                    actions: <Widget>[
                      TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(constants.whiteColor),
                          ),
                          onPressed: () =>
                              {closeResult(), Navigator.pop(context)},
                          child: const Text(
                            'Close',
                            style: TextStyle(color: Color(constants.mainColor)),
                          ))
                    ],
                  ));
            });
      } else {
        controller.pauseCamera();
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return WillPopScope(
                  onWillPop: _onBackPressed,
                  child: AlertDialog(
                    title: const Text(
                      'Scanning',
                      style: TextStyle(color: Color(constants.whiteColor)),
                    ),
                    backgroundColor: const Color(constants.mainColor),
                    content: const Text(
                      'An error occured while scanning the code!',
                      style: TextStyle(color: Color(constants.whiteColor)),
                    ),
                    actions: <Widget>[
                      TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(constants.whiteColor),
                          ),
                          onPressed: () =>
                              {closeResult(), Navigator.pop(context)},
                          child: const Text(
                            'Close',
                            style: TextStyle(color: Color(constants.mainColor)),
                          ))
                    ],
                  ));
            });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
