import 'package:dao_ticketer/types/ticket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dao_ticketer/types/event.dart';
import 'package:dao_ticketer/backend_service/real_implementations/dao_service.impl.dart'
    show RealDAOService;

import 'package:dao_ticketer/screens/render-qr.dart' show GenerateScreen;
import 'package:dao_ticketer/components/event_card.dart' show EventCard;

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key, required this.ticket, required this.event});

  final Ticket ticket;
  final Event event;

  @override
  TicketScreenState createState() => TicketScreenState();
}

class TicketScreenState extends State<TicketScreen> {
  bool initialized = false;

  void fetchTicketsByCategories(fetchedCategories) async {}

  void getEventsData(service) {
    if (initialized) return;
    initialized = true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<RealDAOService>(context);
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
            ElevatedButton(onPressed: () {}, child: const Text('Send ticket'))
          ],
        ),
      ),
    );
  }
}
