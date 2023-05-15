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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ticket')),
      body: SingleChildScrollView(
        child: Column(
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
                        "${widget.ticket.category}, price: ${widget.ticket.price}"),
                  ],
                )),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context,
                      // GenerateScreen(ticket: widget.ticket)
                      AppRouteName.customerGenerateQR,
                      arguments:
                          CustomerGenerateQRScreenArguments(widget.ticket));
                },
                child: const Text('Generate QR code')),
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
                          onSubmitted: (String value) async {
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title:
                                        const Text("Confirm ticket transfer"),
                                    content: Flex(
                                        direction: Axis.vertical,
                                        children: [
                                          Text(
                                              "Send '${widget.event.name}' ticket"),
                                          Text("To $value"),
                                        ]),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          service
                                              .sendTicketTo(
                                                  widget.ticket, value)
                                              .then((_) {
                                            Navigator.pushNamed(context,
                                                AppRouteName.userTickets);
                                          });
                                        },
                                        child: const Text("Confirm"),
                                      )
                                    ],
                                  );
                                });
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(5),
                        child: ElevatedButton(
                            onPressed: () {}, child: const Text('Send ticket')),
                      )
                    ]))
          ],
        ),
      ),
    );
  }
}
