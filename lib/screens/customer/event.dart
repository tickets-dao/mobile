import 'package:dao_ticketer/types/ticket.dart';
import 'package:flutter/material.dart';
import 'package:dao_ticketer/types/event.dart';
import 'package:dao_ticketer/backend_service/mock_implementations/dao_service.impl.dart';
import 'package:dao_ticketer/components/event_card.dart' show EventCard;
import 'package:dao_ticketer/components/event_order_stepper.dart'
    show EventOrderStepper;

class EventScreen extends StatefulWidget {
  const EventScreen({super.key, required this.event});

  final Event event;

  @override
  EventScreenState createState() => EventScreenState();
}

class EventScreenState extends State<EventScreen> {
  List<Ticket> _eventTickets = [];
  MockedDAOService service = MockedDAOService();

  @override
  void initState() {
    super.initState();
    service
        .getTicketsByEvent(widget.event.id, TicketCategory.all)
        .then((eventTickets) {
      setState(() {
        _eventTickets = eventTickets;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.event.name)),
      body: SingleChildScrollView(
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: const Color.fromARGB(249, 242, 253, 255),
            ),
            padding: const EdgeInsets.all(20),
            child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                EventCard(widget.event, false),
                EventOrderStepper(eventTickets: _eventTickets),
              ],
            )),
      ),
    );
  }
}
