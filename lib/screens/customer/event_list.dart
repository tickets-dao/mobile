import 'package:dao_ticketer/types/screen_arguments.dart';
import 'package:flutter/material.dart';
import 'package:dao_ticketer/backend_service/real_implementations/dao_service.impl.dart'
    show RealDAOService;
import 'package:dao_ticketer/types/event.dart' show Event;
import 'package:dao_ticketer/components/event_card.dart' show EventCard;
import 'package:dao_ticketer/types/route_names.dart';

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
      for (Event e in events) {
        e.passed = e.startTime
                .add(const Duration(hours: 3))
                .compareTo(DateTime.now()) <
            0;
      }
      setState(() {
        _events = events;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Доступные мероприятия')),
        body: Container(
          margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          padding: const EdgeInsets.all(10),
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Container>[
                  ..._events.map((event) {
                    return Container(
                        margin: const EdgeInsets.all(10),
                        child: EventCard(
                            event, true, AppRouteName.customerTicketPurchase,
                            buttonText: "купить",
                            redirectArguments:
                                CustomerTicketPurchaseScreenArguments(event)));
                  })
                ]),
          ),
        ));
  }
}
