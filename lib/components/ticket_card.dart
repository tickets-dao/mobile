import 'package:flutter/material.dart';
import 'package:dao_ticketer/types/ticket.dart' show Ticket;
import 'package:dao_ticketer/types/event.dart' show Event;

import 'package:dao_ticketer/screens/customer/ticket.dart' show TicketScreen;
import 'package:intl/intl.dart';

class TicketCard extends StatelessWidget {
  TicketCard(this.ticket, this.event, {super.key}) {
    dateFormatter = DateFormat("dd.MM hh:mm");
  }

  final Ticket ticket;
  final Event event;

  late final DateFormat dateFormatter;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 211, 228, 239),
            spreadRadius: 5,
            blurRadius: 7,
          ),
        ],
      ),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flex(
                    direction: Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event.name),
                      Text("${dateFormatter.format(event.startTime)}"),
                    ]),
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(ticket.category),
                    Text('${ticket.price}'),
                  ],
                ),
              ]),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TicketScreen(ticket: ticket, event: event)),
                );
              },
              child: const Text('Open'))
        ],
      ),
    );
  }
}
