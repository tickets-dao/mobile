import 'dart:async';
import 'dart:convert';
import 'package:dao_ticketer/backend_service/real_implementations/dao_service.impl.dart';
import 'package:dao_ticketer/types/ticket.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<ScanScreen> {
  String _scanBarcode = 'Unknown';
  RealDAOService service = RealDAOService.getSingleton();

  @override
  void initState() {
    super.initState();
  }

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);

      var jsonResp = jsonDecode(barcodeScanRes);

      await service.burnTicket(
          Ticket.fromJson(jsonResp['ticket']), jsonResp['secret']);

      _showAlert(context, "burn succeeded");
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Barcode scan')),
        body: Builder(builder: (BuildContext context) {
          return Container(
              alignment: Alignment.center,
              child: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                        onPressed: () => scanQR(),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: const Text('Открыть сканер',
                              style: TextStyle(fontSize: 20)),
                        )),
                  ]));
        }));
  }

  void _showAlert(BuildContext context, String alert) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text(alert),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
