import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey _key = GlobalKey();
  QRViewController? controller;
  Barcode? result;

  void scanQR(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((event) {
      setState(() {
        result = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QR Scanner")),
      body: Center(
        child: Column(children: [
          Container(
            height: 400,
            width: 400,
            child: QRView(key: _key, onQRViewCreated: scanQR),
          ),
          Center(
            child: (result != null)
                ? Text('${result!.code}')
                : const Text('Scan a code'),
          )
        ]),
      ),
    );
  }
}

//Reference: Vikkybliz. (2022, July 20). QR Code Scanner in Flutter - 2022. Youtube. https://www.youtube.com/watch?v=pKGTKdS8lAs