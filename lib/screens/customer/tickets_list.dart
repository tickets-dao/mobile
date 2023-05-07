import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dao_ticketer/types/ticket.dart';
import 'package:dao_ticketer/types/event.dart';

import 'package:dao_ticketer/backend_service/mock_implementations/dao_service.impl.dart'
    show MockedDAOService;
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

  final mockedService = MockedDAOService();

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

        Future.wait(eventPromises).then((events) {
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
    // TODO: uncomment the real service call
    getTickets(Provider.of<RealDAOService>(context));
    // getTickets(mockedService);
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
