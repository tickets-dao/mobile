import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  bool initialized = false;

  @override
  void initState() {
    super.initState();
  }

  getEventsData(service) {
    if (initialized) return;
    initialized = true;
    service.getEvents().then((events) {
      setState(() {
        _events = events;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<RealDAOService>(context);
    getEventsData(service);
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
