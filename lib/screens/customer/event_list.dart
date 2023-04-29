import 'package:flutter/material.dart';
import 'package:dao_ticketer/backend_service/mock_implementations/dao_service.dart';
import 'package:dao_ticketer/types/event.dart' show Event;

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
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Color.fromARGB(249, 242, 253, 255),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Flex(
                        direction: Axis.vertical,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Text>[
                          Text(event.name),
                          Text(event.address),
                        ]),
                  );
                })
              ]),
        ));
  }
}
