import 'package:dao_ticketer/screens/customer/tickets_list.dart';
import 'package:dao_ticketer/types/ticket.dart';
import 'package:flutter/material.dart';
import 'package:dao_ticketer/types/event.dart';
import 'package:dao_ticketer/backend_service/real_implementations/dao_service.impl.dart'
    show RealDAOService;

import 'package:dao_ticketer/screens/customer/render-qr.dart'
    show GenerateScreen;

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key, required this.ticket, required this.event});

  final Ticket ticket;
  final Event event;

  @override
  TicketScreenState createState() => TicketScreenState();
}

class TicketScreenState extends State<TicketScreen> {
  RealDAOService service = RealDAOService.getSingleton();

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
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: const Color.fromARGB(249, 242, 253, 255),
                ),
                padding: const EdgeInsets.all(20),
                child: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "${widget.event.name}, ${widget.event.startTime.toUtc().toString()}"),
                    Text("${widget.ticket.category}, ${widget.ticket.price}"),
                  ],
                )),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GenerateScreen()),
                  );
                },
                child: const Text('Generate QR code')),
            Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: const Color.fromARGB(249, 242, 253, 255),
                ),
                child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Send ticket to",
                        ),
                        onSubmitted: (String value) async {
                          await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirm ticket transfer"),
                                  content:
                                      Flex(direction: Axis.vertical, children: [
                                    Text("Send '${widget.event.name}' ticket"),
                                    Text("To $value"),
                                  ]),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        service
                                            .sendTicketTo(widget.ticket, value)
                                            .then((_) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const TicketListScreen()),
                                          );
                                        });
                                      },
                                      child: const Text("Confirm"),
                                    )
                                  ],
                                );
                              });
                        },
                      ),
                      ElevatedButton(
                          onPressed: () {}, child: const Text('Send ticket'))
                    ]))
          ],
        ),
      ),
    );
  }
}
