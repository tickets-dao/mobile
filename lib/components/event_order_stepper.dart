import 'package:dao_ticketer/types/ticket.dart';
import 'package:flutter/material.dart';

class EventOrderStepper extends StatefulWidget {
  const EventOrderStepper(
      {super.key,
      required this.eventTicketsByCategory,
      required this.selectTicketCallback});

  final Map<String, List<Ticket>> eventTicketsByCategory;
  final Function selectTicketCallback;

  @override
  EventOrderStepperState createState() => EventOrderStepperState();
}

class EventOrderStepperState extends State<EventOrderStepper> {
  String selectedCategory = "unselected";

  int _selectedSector = 0;
  int number = 0;
  Ticket? selectedTicket;

  int _stepIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tickets = widget.eventTicketsByCategory;
    final List<String> categories = [...widget.eventTicketsByCategory.keys];
    String selectedCategory = categories[0];
    Map<int, Set<int>> rowsBySectors = {};
    Map<int, List<Ticket>> ticketsBySectors = {};

    for (Ticket t in tickets[selectedCategory] ?? []) {
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
          t.sector: {t.row}
        });
      }
    }
    List<int> sectors = [...ticketsBySectors.keys];

    getTicketsCount(int count) =>
        count > 1 ? "$count tickets" : "$count ticket";

    getTicketsByRow(int row) {
      final rowTickets = (tickets[selectedCategory] ?? [])
          .where((ticket) => ticket.row == row);
      return [
        ...rowTickets.map((Ticket ticket) => Wrap(
              children: [
                Radio<Ticket>(
                  groupValue: selectedTicket,
                  value: ticket,
                  onChanged: (Ticket? value) {
                    setState(() {
                      widget.selectTicketCallback(value ?? ticket);
                    });
                  },
                ),
                Text('${ticket.number}'),
              ],
            ))
      ];
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
              ...categories.map((category) {
                return ListTile(
                  title: Text('$category: ${getTicketsCount(tickets.length)}'),
                  leading: Radio<String>(
                    value: category,
                    groupValue: selectedCategory,
                    onChanged: (String? value) {
                      setState(() {
                        selectedCategory = value ?? category;
                      });
                    },
                  ),
                );
              }),
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
              ...rowsBySectors[_selectedSector]?.map((row) {
                    return Flex(
                        direction: Axis.vertical,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('row $row'),
                          Flex(
                            direction: Axis.horizontal,
                            // scrollDirection: Axis.horizontal,
                            children: getTicketsByRow(row),
                          )
                        ]);
                  }) ??
                  []
            ],
          ),
        ),
      ],
    );
  }
}
