import 'package:flutter/material.dart';

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

// TODO: break up the listing into pages
class TicketListScreenState extends State<TicketListScreen> {
  List<Ticket> tickets = [];
  Map<String, Event> eventsMap = {};
  RealDAOService service = RealDAOService.getSingleton();

  fetchTickets() {
    service.getTicketsByUser().then((ts) {
      service
          .getEventsByID(ts.map((Ticket t) => t.eventID).toList())
          .then((events) {
        Map<String, Event> map = {};
        for (Event event in events) {
          print("adding to map");
          map.addAll({event.id: event});
        }
        setState(() {
          tickets = ts;
          eventsMap = map;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchTickets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your tickets')),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.start,
                children: tickets.isNotEmpty
                    ? <Widget>[
                        ...tickets.map((Ticket t) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                            child: TicketCard(t,
                                eventsMap[t.eventID] ?? Event.emptyFallback()),
                          );
                        })
                      ]
                    : [],
              ),
            )),
      ),
    );
  }
}
