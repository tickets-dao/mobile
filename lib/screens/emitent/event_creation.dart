import 'package:dao_ticketer/backend_service/real_implementations/dao_service.impl.dart';
import 'package:dao_ticketer/types/event.dart';
import 'package:dao_ticketer/components/categories_editor.dart'
    show CategoriesEditor;
import 'package:flutter/material.dart';
import 'package:dao_ticketer/screens/emitent/event.dart'
    show EmittentEventScreen;

class EventCreationScreen extends StatefulWidget {
  const EventCreationScreen({super.key});

  @override
  State<EventCreationScreen> createState() => _EventCreationScreenState();
}

class _EventCreationScreenState extends State<EventCreationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name = "";
  String address = "";
  DateTime startDate = DateTime.now();
  String startTime = "";
  // TODO: concatenate the two previous fields to get this following one
  DateTime startDateTime = DateTime.now();
  Map<String, int> categories = {};

  RealDAOService service = RealDAOService.getSingleton();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('event creation')),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  onChanged: (String value) {
                    setState(() {
                      name = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name of the event",
                  ),
                ),
                TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Event address",
                    ),
                    onChanged: (String value) {
                      setState(() {
                        startTime = value;
                      });
                    }),
                InputDatePickerFormField(
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  onDateSubmitted: (DateTime dt) {
                    setState(() {
                      startDate = dt;
                    });
                  },
                ),
                TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Event start time",
                    ),
                    onChanged: (String value) {
                      setState(() {
                        startTime = value;
                      });
                    }),
                CategoriesEditor(
                    value: categories,
                    onChanged: (value) {
                      setState(() {
                        categories = value;
                      });
                    }),
                ElevatedButton(
                  child: const Text('create event'),
                  onPressed: () {
                    service
                        .createEvent(
                            Event(startDateTime, address, name, ""), categories)
                        .then((eid) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EmittentEventScreen(eventID: eid)),
                      );
                    });
                  },
                )
              ]),
        ),
      ),
    );
  }
}
