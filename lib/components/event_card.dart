import 'package:flutter/material.dart';
import 'package:dao_ticketer/types/event.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final bool renderButton;
  final String redirectTo;
  final Object? redirectArguments;
  final String buttonText;
  late final DateFormat dateFormatter;

  EventCard(this.event, this.renderButton, this.redirectTo,
      {this.redirectArguments, required this.buttonText, super.key}) {
    dateFormatter = DateFormat("dd.MM hh:mm");
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> getChildren() {
      Flex eventInfo = Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(event.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
              child: Text(event.address),
            ),
            Text(dateFormatter.format(event.startTime)),
          ]);
      return renderButton
          ? [
              eventInfo,
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, redirectTo,
                        arguments: redirectArguments);
                  },
                  child: Text(buttonText, style: const TextStyle(fontSize: 15)))
            ]
          : [eventInfo];
    }

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
      padding: const EdgeInsets.all(10),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: getChildren(),
      ),
    );
  }
}
