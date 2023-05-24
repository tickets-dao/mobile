import 'package:dao_ticketer/screens/shared/tickets_list.dart';
import 'package:dao_ticketer/types/route_names.dart';
import 'package:dao_ticketer/types/screen_arguments.dart';
import 'package:dao_ticketer/types/ticket.dart';
import 'package:flutter/material.dart';
import 'package:dao_ticketer/types/event.dart';
import 'package:dao_ticketer/backend_service/real_implementations/dao_service.impl.dart'
    show RealDAOService;

import 'package:dao_ticketer/screens/customer/render_qr.dart'
    show GenerateScreen;
import 'package:intl/intl.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key, required this.ticket, required this.event});

  final Ticket ticket;
  final Event event;

  @override
  TicketScreenState createState() => TicketScreenState();
}

class TicketScreenState extends State<TicketScreen> {
  RealDAOService service = RealDAOService.getSingleton();
  late final DateFormat dateFormatter = DateFormat("dd.MM hh:mm");
  String sendTo = "";

  @override
  void initState() {
    super.initState();
  }

  showConfirmationDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirm ticket transfer"),
            content: Flex(direction: Axis.vertical, children: [
              Text("Send '${widget.event.name}' ticket"),
              Text("To $sendTo"),
            ]),
            actions: [
              TextButton(
                onPressed: () {
                  service.sendTicketTo(widget.ticket, sendTo).then((_) {
                    Navigator.pushNamed(context, AppRouteName.userTickets);
                  });
                },
                child: const Text("Confirm"),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ticket')),
      body: SingleChildScrollView(
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                child: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(widget.event.name,
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    Text(dateFormatter.format(widget.event.startTime),
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    Text(
                        "${widget.ticket.category}, row: ${widget.ticket.row}, seat: ${widget.ticket.number}",
                        style: const TextStyle(fontSize: 20)),
                  ],
                )),
            const Divider(),
            Container(
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, AppRouteName.customerGenerateQR,
                        arguments:
                            CustomerGenerateQRScreenArguments(widget.ticket));
                  },
                  child: const Text('Generate QR code',
                      style: TextStyle(fontSize: 18))),
            ),
            Container(
                margin: const EdgeInsets.all(10),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.orange)),
                  onPressed: () {
                    service.returnTicket(widget.ticket);
                  },
                  child: const Text("Return ticket",
                      style: TextStyle(fontSize: 18)),
                )),
            const Divider(),
            Container(
                margin: const EdgeInsets.all(10),
                child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Send ticket to",
                          ),
                          onChanged: (String value) {
                            setState(() {
                              sendTo = value;
                            });
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.blue),
                          onPressed: () {
                            showConfirmationDialog();
                          },
                        ),
                      )
                    ])),
          ],
        ),
      ),
    );
  }
}
