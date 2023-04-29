import 'package:flutter/material.dart';
import 'package:dao_ticketer/types/event.dart';

class EventListCard extends StatelessWidget {
  const EventListCard(this.event);

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: const Color.fromARGB(249, 242, 253, 255),
      ),
      padding: const EdgeInsets.all(20),
      child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Text>[
            Text(event.name),
            Text(event.address),
          ]),
    );
  }
}
