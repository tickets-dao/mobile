import 'package:flutter/material.dart';
import 'package:dao_ticketer/backend_service/real_implementations/dao_service.impl.dart'
    show RealDAOService;
import 'package:dao_ticketer/types/event.dart' show Event;
import 'package:dao_ticketer/components/event_card.dart' show EventCard;

class EventsListScreen extends StatefulWidget {
  const EventsListScreen({super.key});

  @override
  EventListScreenState createState() => EventListScreenState();
}

class EventListScreenState extends State<EventsListScreen> {
  List<Event> _events = [];
  RealDAOService service = RealDAOService.getSingleton();

  @override
  void initState() {
    super.initState();
    service.getEvents().then((events) {
      setState(() {
        _events = events;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Available events')),
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Container>[
                  ..._events.map((event) {
                    return Container(
                        margin: const EdgeInsets.all(10),
                        child: EventCard(event, true));
                  })
                ]),
          ),
        ));
  }
}
