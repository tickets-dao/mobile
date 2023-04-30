import 'package:flutter/material.dart';
import 'package:dao_ticketer/backend_service/mock_implementations/dao_service.impl.dart';
import 'package:dao_ticketer/types/event.dart' show Event;
import 'package:dao_ticketer/components/event_list_card.dart'
    show EventListCard;
import 'package:dao_ticketer/screens/customer/event.dart' show EventScreen;

class EventsListScreen extends StatefulWidget {
  const EventsListScreen({super.key});

  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventsListScreen> {
  List<Event> _events = [];
  MockedDAOService service = MockedDAOService();

  @override
  void initState() {
    super.initState();
    service.getEvents().then((events) {
      _events = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Available events')),
        body: Container(
          alignment: Alignment.center,
          child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Container>[
                ..._events.map((event) {
                  return Container(
                      margin: const EdgeInsets.all(10),
                      child: EventListCard(event));
                })
              ]),
        ));
  }
}
