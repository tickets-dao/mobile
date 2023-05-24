import 'package:dao_ticketer/types/route_names.dart';
import 'package:flutter/material.dart';
import 'package:dao_ticketer/types/ticket.dart' show Ticket;
import 'package:dao_ticketer/types/event.dart' show Event;
import 'package:dao_ticketer/types/screen_arguments.dart';
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Text(event.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Text(dateFormatter.format(event.startTime)),
                Text(
                    "${ticket.category} ряд ${ticket.row} место ${ticket.number}"),
              ]),
          IconButton(
              icon: const Icon(
                Icons.visibility,
                color: Colors.blue,
                size: 30,
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRouteName.userTicket,
                  arguments: TicketScreenArguments(ticket, event),
                );
              })
        ],
      ),
    );
  }
}
