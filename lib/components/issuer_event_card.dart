import 'package:dao_ticketer/screens/issuer/event.dart';
import 'package:flutter/material.dart';
import 'package:dao_ticketer/types/event.dart';

class IssuerEventCard extends StatelessWidget {
  const IssuerEventCard(this.event, this.renderButton, {super.key});

  final Event event;
  final bool renderButton;

  @override
  Widget build(BuildContext context) {
    List<Widget> getChildren() {
      Flex eventInfo = Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Text>[
            Text(event.name),
            Text(event.address),
          ]);
      return renderButton
          ? [
              eventInfo,
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              IssuerEventScreen(event: event)),
                    );
                  },
                  child: const Text('Open'))
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
      padding: const EdgeInsets.all(20),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: getChildren(),
      ),
    );
  }
}
