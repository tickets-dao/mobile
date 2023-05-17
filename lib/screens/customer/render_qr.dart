import 'package:dao_ticketer/backend_service/real_implementations/dao_service.impl.dart';
import 'package:dao_ticketer/backend_service/real_implementations/local_store_service.impl.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:dao_ticketer/types/ticket.dart';

import 'dart:math';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

class GenerateScreen extends StatefulWidget {
  const GenerateScreen({required this.ticket, super.key});

  final Ticket ticket;

  @override
  State<StatefulWidget> createState() => GenerateScreenState();
}

class GenerateScreenState extends State<GenerateScreen> {
  GlobalKey globalKey = GlobalKey();
  RealDAOService service = RealDAOService.getSingleton();
  DAOLocalStoreService lsService = DAOLocalStoreService.getSingleton();
  bool ticketPrepared = false;
  late final String _secret;

  rememberSecret() {
    service.prepareTicket(widget.ticket, _secret).then((_) {
      setState(() {
        ticketPrepared = true;
      });
      print("Your secret for ticket: $_secret");
    });
  }

  @override
  void initState() {
    super.initState();

    String? rememberedSecret = lsService.getLocalTicketSecret(widget.ticket);

    _secret = rememberedSecret ?? getRandomString(10);

    if (rememberedSecret == null || rememberedSecret == "") {
      rememberSecret();
    } else {
      setState(() {
        ticketPrepared = true;
      });
      print("Your secret for ticket: $_secret");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket QR'),
      ),
      body: _contentWidget(),
    );
  }

  _contentWidget() {
    final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    return Container(
      color: const Color(0xFFFFFFFF),
      child: ticketPrepared
          ? Column(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: RepaintBoundary(
                      key: globalKey,
                      child: QrImage(
                        data: _secret,
                        size: 0.5 * bodyHeight,
                        // onError: (ex) {
                        //   setState(() {
                        //     _inputErrorText =
                        //         "Error! Maybe your input value is too long?";
                        //   });
                        // },
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Text("Generating your secret...",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
    );
  }
}
