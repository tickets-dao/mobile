import 'package:dao_ticketer/backend_service/real_implementations/dao_service.impl.dart';
import 'package:dao_ticketer/types/event.dart';
import 'package:dao_ticketer/components/categories_editor.dart'
    show CategoriesEditor;
import 'package:dao_ticketer/types/price_category.dart';
import 'package:flutter/material.dart';
import 'package:dao_ticketer/screens/issuer/event.dart'
    show EmittentEventScreen;
import 'package:dao_ticketer/components/date_picker.dart' show DatePickerWidget;
import 'package:dao_ticketer/components/time_picker.dart' show TimePickerWidget;
import 'package:intl/intl.dart';

class EventCreationScreen extends StatefulWidget {
  const EventCreationScreen({super.key});

  @override
  State<EventCreationScreen> createState() => _EventCreationScreenState();
}

class _EventCreationScreenState extends State<EventCreationScreen> {
  String name = "";
  String address = "";
  DateTime startDateTime = DateTime.now();
  List<PriceCategory> categories = [];

  final dateFormatter = DateFormat("dd.MM hh:mm");

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
              Text("Start time: ${dateFormatter.format(startDateTime)}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DatePickerWidget(
                      onSelected: (value) {
                        setState(() {
                          startDateTime = value;
                        });
                      },
                    ),
                    TimePickerWidget(
                      onSelected: (TimeOfDay time) {
                        setState(() {
                          startDateTime = startDateTime.add(
                              Duration(hours: time.hour, minutes: time.minute));
                        });
                      },
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              //   child:
              // ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Text("Edit categories",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
