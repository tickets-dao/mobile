import 'package:flutter/material.dart';
import 'package:dao_ticketer/types/ticket.dart' show Ticket;
import 'package:dao_ticketer/types/event.dart' show Event;

import 'package:dao_ticketer/screens/customer/ticket.dart' show TicketScreen;

class TicketCard extends StatelessWidget {
  const TicketCard(this.ticket, this.event, {super.key});

  final Ticket ticket;
  final Event event;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(event.name),
                      Text(event.startTime.toUtc().toString()),
                    ]),
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
