import 'package:dao_ticketer/types/price_category.dart';
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

  int number = 0;
  Ticket? selectedTicket;

  int _stepIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tickets = widget.eventTicketsByCategory;
    final List<String> categories = [...widget.eventTicketsByCategory.keys];
    String selectedCategory = categories[0];
    Map<String, Set<int>> rowsByCategories = {};

    for (String category in categories) {
      rowsByCategories.addAll({
        category: tickets[category]?.map((Ticket t) => t.row).toSet() ?? {}
      });
    }

    getTicketsCount(int count) =>
        count > 1 ? "$count tickets" : "$count ticket";

    getTicketsByRow(int row) {
      final rowTickets = (tickets[selectedCategory] ?? [])
          .where((ticket) => ticket.row == row);
      return [
        ...rowTickets.map((Ticket ticket) => Row(
              children: [
                Radio<Ticket>(
                  groupValue: selectedTicket,
                  value: ticket,
                  onChanged: (Ticket? value) {
                    setState(() {
                      selectedTicket = value ?? ticket;
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
        if (_stepIndex < 2) {
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
          title: const Text('Select row'),
          content: Column(
            children: <Widget>[
              ...rowsByCategories[selectedCategory]?.map((row) {
                    return Flex(
                        direction: Axis.vertical,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('row $row'),
                          Wrap(
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
