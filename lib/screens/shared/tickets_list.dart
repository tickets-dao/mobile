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

  @override
  void initState() {
    super.initState();
    service.getTicketsByUser().then((ts) {
      setState(() {
        tickets = ts;

        service
            .getEventsByID(ts.map((Ticket t) => t.eventID).toList())
            .then((events) {
          Map<String, Event> map = {};
          for (Event event in events) {
            map.addAll({event.id: event});
          }
          setState(() {
            eventsMap = map;
          });
        });
      });
    });
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
                children: eventsMap.length == tickets.length
                    ? <Widget>[
                        ...tickets.map((Ticket t) {
                          return TicketCard(
                              t, eventsMap[t.eventID] ?? Event.emptyFallback());
                        })
                      ]
                    : [],
              ),
            )),
      ),
    );
  }
}