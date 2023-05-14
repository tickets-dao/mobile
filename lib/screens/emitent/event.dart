import 'package:dao_ticketer/backend_service/real_implementations/dao_service.impl.dart';
import 'package:flutter/material.dart';
import 'package:dao_ticketer/types/event.dart';
import 'package:dao_ticketer/components/event_card.dart';
import 'package:dao_ticketer/components/categories_editor.dart';
import 'package:dao_ticketer/screens/emitent/emission.dart'
    show TicketEmissionScreen;

class EmittentEventScreen extends StatefulWidget {
  const EmittentEventScreen({this.event, this.eventID, super.key});

  final Event? event;
  final String? eventID;

  @override
  State<EmittentEventScreen> createState() => _EmittentEventScreenState();
}

class _EmittentEventScreenState extends State<EmittentEventScreen> {
  Event event = Event.emptyFallback();
  Map<String, int> categories = {};
  RealDAOService service = RealDAOService.getSingleton();

  void initEventData() async {
    if (widget.event == null) {
      List<Event> respEvents = await service
          .getEventsByID([widget.eventID ?? "uninitialized event ID"]);
      event = respEvents[0];
    } else {
      event = widget.event ?? Event.emptyFallback();
    }
    service
        .getEmittentEventCategories(
            widget.event?.id ?? "uninitialized event ID")
        .then((cs) {
      setState(() {
        categories = cs;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initEventData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            EventCard(event, false),
            CategoriesEditor(
              value: categories,
              onChanged: (value) {
                setState(() {
                  categories = value;
                });
              },
              fixCategoryKeys: true,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TicketEmissionScreen(event: event)),
                  );
                },
                child: const Text('Issue tickets'))
          ],
        ),
      ),
    );
  }
}