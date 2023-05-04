import 'package:dao_ticketer/types/ticket.dart';
import 'package:flutter/material.dart';

class EventOrderStepper extends StatefulWidget {
  const EventOrderStepper({super.key, required this.eventTicketsByCategory});

  final Map<String, List<Ticket>> eventTicketsByCategory;

  @override
  EventOrderStepperState createState() => EventOrderStepperState();
}

class EventOrderStepperState extends State<EventOrderStepper> {
  String _selectedCategory = "unselected";

  int _selectedSector = 0;
  int number = 0;
  final List<Ticket> _selectedTickets = [];

  int _stepIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tickets = widget.eventTicketsByCategory;
    Map<int, List<int>> rowsBySectors = {};
    Map<int, List<Ticket>> ticketsBySectors = {};

    // TODO: this map should somehow be restricted to the selected category only
    for (Ticket t in tickets) {
      if (ticketsBySectors.containsKey(t.sector)) {
        ticketsBySectors[t.sector]?.add(t);
      } else {
        ticketsBySectors.addAll({
          t.sector: [t]
        });
      }
      if (rowsBySectors.containsKey(t.sector)) {
        rowsBySectors[t.sector]?.add(t.row);
      } else {
        rowsBySectors.addAll({
          t.sector: [t.row]
        });
      }
    }
    List<int> sectors = [...ticketsBySectors.keys];

    getTicketsCount(int count) =>
        count > 1 ? "$count tickets" : "$count ticket";

    return Stepper(
      currentStep: _stepIndex,
      onStepCancel: () {
        if (_stepIndex > 0) {
          setState(() {
            _stepIndex -= 1;
          });
        }
      },
      onStepContinue: () {
        if (_stepIndex <= 0) {
          setState(() {
            _stepIndex += 1;
          });
        }
      },
      onStepTapped: (int index) {
        setState(() {
          _stepIndex = index;
        });
      },
      steps: <Step>[
        Step(
          title: const Text('Select category'),
          content: Column(
            children: <Widget>[
              ListTile(
                title: Text('Lodge: ${getTicketsCount(tickets.length)}'),
                leading: Radio<String>(
                  value: String,
                  groupValue: _selectedCategory,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedCategory = value ?? String;
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('Parter: ${getTicketsCount(tickets.length)}'),
                leading: Radio<String>(
                  value: String.parter,
                  groupValue: _selectedCategory,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedCategory = value ?? String.parter;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Step(
            title: const Text('Select sector'),
            content: Column(
              children: <Widget>[
                ...sectors.map((int s) => ListTile(
                      title: Text(
                          'Sector $s: ${getTicketsCount(ticketsBySectors[s]?.length ?? 0)}'),
                      leading: Radio<int>(
                          value: s,
                          groupValue: _selectedSector,
                          onChanged: (int? value) {
                            setState(() {
                              _selectedSector = value ?? s;
                            });
                          }),
                    )),
              ],
            )),
        Step(
          title: const Text('Select row'),
          content: Column(
            children: <Widget>[
              ...rowsBySectors[_selectedSector]?.map((row) => Flex(
                          direction: Axis.vertical,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Row $row, seats:'),
                            Row(
                              children: [
                                ...(ticketsBySectors[_selectedSector]
                                        ?.map((t) => Row(
                                              children: [
                                                Checkbox(
                                                    value: false,
                                                    onChanged: (bool? value) {
                                                      if (value ?? false) {
                                                        // setState(() {
                                                        //   _selectedTickets.add(t);
                                                        // });
                                                        _selectedTickets.add(t);
                                                      } else {
                                                        _selectedTickets
                                                            .remove(t);
                                                      }
                                                    }),
                                                Text("${t.number}")
                                              ],
                                            )) ??
                                    [])
                              ],
                            )
                          ])) ??
                  []
            ],
          ),
        ),
      ],
    );
  }
}
