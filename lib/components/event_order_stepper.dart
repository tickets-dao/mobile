import 'package:dao_ticketer/types/ticket.dart';
import 'package:flutter/material.dart';

class EventOrderStepper extends StatefulWidget {
  const EventOrderStepper({super.key, required this.eventTickets});

  final List<Ticket> eventTickets;

  @override
  EventOrderStepperState createState() => EventOrderStepperState();
}

class EventOrderStepperState extends State<EventOrderStepper> {
  TicketCategory _selectedCategory = TicketCategory.all;

  int _selectedSector = 0;
  int number = 0;

  int _stepIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tickets = widget.eventTickets;
    final sectorsSet = Set.from(tickets.map((Ticket t) => t.sector));
    List<int> sectors = [];
    Map<int, List<int>> rowsBySectors = {};
    Map<int, List<Ticket>> ticketsBySectors = {};
    // final List<List<int>> _rowsBySectors
    for (int sector in sectorsSet) {
      sectors.add(sector);
      if (!rowsBySectors.containsKey(sector)) {
        ticketsBySectors.addAll({sector: []});
      }
    }
    for (Ticket t in widget.eventTickets) {
      rowsBySectors[t.sector]?.add(t.row);
      ticketsBySectors[t.sector]?.add(t);
    }
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
                title: const Text('Lodge'),
                leading: Radio<TicketCategory>(
                  value: TicketCategory.lodge,
                  groupValue: _selectedCategory,
                  onChanged: (TicketCategory? value) {
                    setState(() {
                      _selectedCategory = value ?? TicketCategory.lodge;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Parter'),
                leading: Radio<TicketCategory>(
                  value: TicketCategory.parter,
                  groupValue: _selectedCategory,
                  onChanged: (TicketCategory? value) {
                    setState(() {
                      _selectedCategory = value ?? TicketCategory.parter;
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
                      title: Text('Sector $s'),
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
        const Step(
          title: const Text('Select row'),
          content: const Text('awooga'),
        ),
      ],
    );
  }
}
