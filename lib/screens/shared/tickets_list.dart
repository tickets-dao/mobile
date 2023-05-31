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

  fetchTickets() async {
    List<Ticket> ts = await service.getTicketsByUser();
    List<Event> events =
        await service.getEventsByID(ts.map((Ticket t) => t.eventID).toList());
    Map<String, Event> map = {};
    events.asMap().forEach((index, event) {
      map.addAll({event.id: event});
      ts[index].expired = event.startTime.compareTo(DateTime.now()) < 0;
    });
    setState(() {
      tickets = ts;
      eventsMap = map;
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
      appBar: AppBar(title: const Text('Мои билеты')),
      body: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            padding: const EdgeInsets.all(10),
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
