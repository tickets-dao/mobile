import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dao_ticketer/types/ticket.dart';
import 'package:dao_ticketer/types/event.dart';
import 'package:dao_ticketer/backend_service/real_implementations/dao_service.impl.dart'
    show RealDAOService;
import 'package:dao_ticketer/components/ticket_card.dart' show TicketCard;

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key});

  @override
  TicketListScreenState createState() => TicketListScreenState();
}

class TicketListScreenState extends State<TicketListScreen> {
  List<Ticket> tickets = [];
  Map<String, Event> eventsMap = {};
  bool initialized = false;

  @override
  void initState() {
    super.initState();
  }

  getTickets(service) {
    if (initialized) return;
    initialized = true;
    service.getTicketsByUser().then((tickets) {
      setState(() {
        tickets = tickets;
        List<Future> eventPromises = tickets.map((Ticket t) {
          return service.getEventByID(t.eventID);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    getTickets(Provider.of<RealDAOService>(context));
    return Scaffold(
      appBar: AppBar(title: const Text('Your tickets')),
      body: SingleChildScrollView(
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: const Color.fromARGB(249, 242, 253, 255),
            ),
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ...tickets.map((Ticket t) {
                    return TicketCard(t);
                  })
                ],
              ),
            )),
      ),
    );
  }
}
