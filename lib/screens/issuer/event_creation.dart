import 'package:dao_ticketer/backend_service/real_implementations/dao_service.impl.dart';
import 'package:dao_ticketer/types/event.dart';
import 'package:dao_ticketer/components/categories_editor.dart'
    show CategoriesEditor;
import 'package:flutter/material.dart';
import 'package:dao_ticketer/screens/issuer/event.dart'
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: TextField(
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
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Event address",
                    ),
                    onChanged: (String value) {
                      setState(() {
                        startTime = value;
                      });
                    }),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: InputDatePickerFormField(
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  onDateSubmitted: (DateTime dt) {
                    setState(() {
                      startDate = dt;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Event start time",
                    ),
                    onChanged: (String value) {
                      setState(() {
                        startTime = value;
                      });
                    }),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: CategoriesEditor(
                    value: categories,
                    onChanged: (value) {
                      setState(() {
                        categories = value;
                      });
                    }),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: ElevatedButton(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
