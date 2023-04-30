import 'package:dao_ticketer/types/ticket.dart';
import 'package:flutter/material.dart';
import 'package:dao_ticketer/types/event.dart';
import 'package:dao_ticketer/backend_service/mock_implementations/dao_service.impl.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key, required this.event});

  final Event event;

  @override
  EventScreenState createState() => EventScreenState();
}

class EventScreenState extends State<EventScreen> {
  var _eventTickets;
  MockedDAOService service = MockedDAOService();

  @override
  void initState() {
    super.initState();
    service
        .getTicketsByEvent(widget.event.id, TicketCategory.all, 2)
        .then((eventTickets) {
      _eventTickets = eventTickets;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.event.name)),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: const Color.fromARGB(249, 242, 253, 255),
        ),
        padding: const EdgeInsets.all(20),
        child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Text>[
              Text(widget.event.name),
              Text(widget.event.address),
            ]),
      ),
    );
  }
}
