import 'package:dao_ticketer/components/event_card.dart';
import 'package:dao_ticketer/types/route_names.dart';
import 'package:dao_ticketer/types/screen_arguments.dart';
import 'package:flutter/material.dart';
import 'package:dao_ticketer/types/event.dart';
import 'package:dao_ticketer/backend_service/real_implementations/dao_service.impl.dart';

class IssuerEventsListScreen extends StatefulWidget {
  const IssuerEventsListScreen({super.key});

  @override
  State<IssuerEventsListScreen> createState() => _IssuerEventsListScreenState();
}

class _IssuerEventsListScreenState extends State<IssuerEventsListScreen> {
  List<Event> events = [];
  RealDAOService service = RealDAOService.getSingleton();

  List<Widget> getEventCardWidgets() {
    return [
      ...events.map((e) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: EventCard(e, true, AppRouteName.issuerEvent,
             redirectArguments: IssuerEventScreenArguments(e, null)),
        );
      })
    ];
  }

  @override
  initState() {
    super.initState();
    service.getEventsByIssuer().then((es) {
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: getEventCardWidgets(),
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        child: const Text('+ add new event'),
        onPressed: () {
          Navigator.pushNamed(context, AppRouteName.issuerEventCreation);
        },
      ),
    );
  }
}
