import 'package:dao_ticketer/screens/customer/event.dart';
import 'package:flutter/material.dart';
import 'package:dao_ticketer/types/event.dart';

class EventListCard extends StatelessWidget {
  const EventListCard(this.event);

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
      padding: const EdgeInsets.all(20),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Text>[
                Text(event.name),
                Text(event.address),
              ]),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EventScreen(event: event)),
                );
              },
              child: const Text('tickets'))
        ],
      ),
    );
  }
}
