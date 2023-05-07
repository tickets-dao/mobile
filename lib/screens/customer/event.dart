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
  Ticket? selectedTicket;

  late final RealDAOService service;

  selectTicket(Ticket newTicket) {
    setState(() {
      selectedTicket = newTicket;
    });
  }

  @override
  void initState() {
    super.initState();
    service = RealDAOService.getSingleton();
    service.getCategories(widget.event.id).then((fetchedCategories) async {
      // once the categories are fetched,
      // use the service to get all the tickets by those categories
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
    });
  }

  List<Widget> getEventWidgetChildren() {
    if (_eventTicketsByCategory.isEmpty) {
      return [EventCard(widget.event, false)];
    } else {
      return [
        EventCard(widget.event, false),
        EventOrderStepper(
            eventTicketsByCategory: _eventTicketsByCategory,
            selectTicketCallback: selectTicket),
      ];
    }
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
                children: getEventWidgetChildren(),
              )),
        ),
        floatingActionButton: selectedTicket != null
            ? ElevatedButton(
                child: Text(
                    "sector ${selectedTicket?.sector} | row ${selectedTicket?.row} | seat ${selectedTicket?.number} | price ${selectedTicket?.price}"),
                onPressed: () {
                  if (selectedTicket != null) {
                    service.buyTicket(selectedTicket ??
                        Ticket.fromJson(
                            {})); // I am struggling to make it work with a Ticket? type argument :()
                  }
                },
              )
            : null);
  }
}
