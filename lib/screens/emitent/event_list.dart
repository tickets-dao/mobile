import 'package:dao_ticketer/components/event_card.dart';
import 'package:flutter/material.dart';
import 'package:dao_ticketer/types/event.dart';
import 'package:dao_ticketer/screens/emitent/event_creation.dart';
import 'package:dao_ticketer/backend_service/real_implementations/dao_service.impl.dart';

class EmitterEventsListScreen extends StatefulWidget {
  const EmitterEventsListScreen({super.key});

  @override
  State<EmitterEventsListScreen> createState() =>
      _EmitterEventsListScreenState();
}

class _EmitterEventsListScreenState extends State<EmitterEventsListScreen> {
  List<Event> events = [];
  RealDAOService service = RealDAOService.getSingleton();

  List<Widget> getEventCardWidgets() {
    return [
      ...events.map((e) {
        return EventCard(e, true);
      })
    ];
  }

  @override
  initState() {
    super.initState();
    service.getEventsByEmittent().then((es) {
      setState(() {
        events = es;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Created events')),
      body: SingleChildScrollView(
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: getEventCardWidgets(),
        ),
      ),
      floatingActionButton: ElevatedButton(
        child: const Text('+ add new event'),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const EventCreationScreen()));
        },
      ),
    );
  }
}
