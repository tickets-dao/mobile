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
  int number = 0;
  Ticket? selectedTicket;

  int _stepIndex = 0;

  late Map<String, List<Ticket>> tickets;
  List<String> categories = [];
  late String selectedCategory = "unselected";

  int selectedRow = 0;
  Map<String, Set<int>> rowsByCategories = {};

  @override
  void initState() {
    super.initState();
    tickets = widget.eventTicketsByCategory;
    categories = [...widget.eventTicketsByCategory.keys];
    Map<String, Set<int>> map = {};
    for (String category in categories) {
      map.addAll({
        category: tickets[category]?.map((Ticket t) => t.row).toSet() ?? {}
      });
    }
    rowsByCategories = map;

    for (String category in rowsByCategories.keys) {
      print("added category $category");
    }
  }

  getTicketsCount(int count) {
    final int remainder10 = count % 10;
    final int fullDiv10 = int.parse(((count % 100) / 10).toStringAsFixed(0));
    if (remainder10 == 0) return "$count билетов";
    if (remainder10 == 1) {
      if (fullDiv10 != 1) {
        return "$count билет";
      } else {
        return "$count билетов";
      }
    }
    if (remainder10 <= 4) {
      return "$count билета";
    }

    return "$count билетов";
  }

  getEventRowsByCategory(String category) {
    print("gettin tickets by category $category");
    return [
      ...(rowsByCategories[category]?.toList() ?? []).map((row) => Row(
            children: [
              Radio<int>(
                groupValue: selectedRow,
                value: row,
                onChanged: (int? tappedRow) {
                  print("row tapped: $tappedRow");
                  setState(() {
                    selectedRow = tappedRow ?? row;
                  });
                },
              ),
              Text("$row")
            ],
          ))
    ];
  }

  getTicketsByRow(int row) {
    final rowTickets =
        (tickets[selectedCategory] ?? []).where((ticket) => ticket.row == row);
    return [
      Wrap(direction: Axis.horizontal, children: [
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
      ])
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Stepper(
      physics: const ClampingScrollPhysics(),
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
          title: selectedCategory == "unselected"
              ? const Text('Выберите категорию')
              : Text(selectedCategory),
          content: Column(
            children: <Widget>[
              ...categories.map((category) {
                return ListTile(
                  title: Text('$category: ${getTicketsCount(tickets.length)}'),
                  leading: Radio<String>(
                    value: category,
                    groupValue: selectedCategory,
                    onChanged: (String? value) {
                      String newCategory = value ?? category;
                      print("new category: $newCategory");
                      setState(() {
                        selectedCategory = newCategory;
                      });
                    },
                  ),
                );
              }),
            ],
          ),
        ),
        Step(
            title: selectedRow == 0
                ? const Text('Выберите ряд')
                : Text("Ряд $selectedRow"),
            content: Wrap(
                direction: Axis.horizontal,
                children: getEventRowsByCategory(selectedCategory))),
        Step(
          title: const Text('Выберите место'),
          content: Column(
            children: getTicketsByRow(selectedRow),
          ),
        ),
      ],
    );
  }
}
