import 'package:dao_ticketer/types/ticket.dart';
import 'package:flutter/material.dart';
import 'package:dao_ticketer/types/event.dart';
import 'package:dao_ticketer/backend_service/real_implementations/dao_service.impl.dart'
    show RealDAOService;
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
  List<String> _eventCategories = [];
  Map<String, List<Ticket>> _eventTicketsByCategory = {};
  RealDAOService service = RealDAOService();

  @override
  void initState() async {
    super.initState();
    final fetchedCategories = await service.getCategories(widget.event.id);
    setState(() {
      _eventCategories = fetchedCategories;
    });
    final ticketFutures = <Future<List<Ticket>>>[];
    for (String category in _eventCategories) {
      ticketFutures.add(service.getAvailableTicketsByEventAndCategory(
          widget.event.id, category));
    }
    final List<List<Ticket>> ticketsByCategory =
        await Future.wait(ticketFutures);

    final Map<String, List<Ticket>> catTicketsMap = {};

    _eventCategories.asMap().forEach((index, category) {
      catTicketsMap.addAll({category: ticketsByCategory[index]});
    });

    setState(() {
      _eventTicketsByCategory = catTicketsMap;
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
                EventOrderStepper(
                    eventTicketsByCategory: _eventTicketsByCategory),
              ],
            )),
      ),
    );
  }
}
