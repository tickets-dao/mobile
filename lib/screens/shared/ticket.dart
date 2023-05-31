import 'package:dao_ticketer/types/route_names.dart';
import 'package:dao_ticketer/types/screen_arguments.dart';
import 'package:dao_ticketer/types/ticket.dart';
import 'package:flutter/material.dart';
import 'package:dao_ticketer/types/event.dart';
import 'package:dao_ticketer/backend_service/real_implementations/dao_service.impl.dart'
    show RealDAOService;
import 'package:intl/intl.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key, required this.ticket, required this.event});

  final Ticket ticket;
  final Event event;

  @override
  TicketScreenState createState() => TicketScreenState();
}

class TicketScreenState extends State<TicketScreen> {
  RealDAOService service = RealDAOService.getSingleton();
  late final DateFormat dateFormatter = DateFormat("dd.MM hh:mm");
  late final bool expired;
  String sendTo = "";

  @override
  void initState() {
    super.initState();
    expired = widget.event.startTime.compareTo(DateTime.now()) < 0;
  }

  showConfirmationDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Подтверждение передачи билета"),
            content: Flex(direction: Axis.vertical, children: [
              Text(
                  "Вы уверены, что хотите передать билет на '${widget.event.name}'"),
              Text("пользователю с адресом $sendTo"),
            ]),
            actions: [
              TextButton(
                onPressed: () {
                  service.sendTicketTo(widget.ticket, sendTo).then((_) {
                    Navigator.pushNamed(context, AppRouteName.userTickets);
                  });
                },
                child: const Text("Да"),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Билет')),
      body: SingleChildScrollView(
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                child: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(widget.event.name,
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    Text(dateFormatter.format(widget.event.startTime),
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    Text(
                        "${widget.ticket.category}, ряд: ${widget.ticket.row}, место: ${widget.ticket.number}",
                        style: const TextStyle(fontSize: 20)),
                    expired
                        ? const Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text("просрочен",
                                style: TextStyle(
                                    fontSize: 17, color: Colors.orange)),
                          )
                        : Container(),
                  ],
                )),
            const Divider(),
            expired
                ? Container()
                : Container(
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, AppRouteName.customerGenerateQR,
                              arguments: CustomerGenerateQRScreenArguments(
                                  widget.ticket));
                        },
                        child: const Text('Сгенерировать QR',
                            style: TextStyle(fontSize: 18))),
                  ),
            expired
                ? Container()
                : Container(
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.orange)),
                      onPressed: () {
                        service.returnTicket(widget.ticket);
                      },
                      child: const Text("Вернуть билет",
                          style: TextStyle(fontSize: 18)),
                    )),
            expired ? Container() : const Divider(),
            expired
                ? Container()
                : Container(
                    margin: const EdgeInsets.all(10),
                    child: Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Адрес отправки",
                              ),
                              onChanged: (String value) {
                                setState(() {
                                  sendTo = value;
                                });
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: IconButton(
                              icon: const Icon(Icons.send, color: Colors.blue),
                              onPressed: () {
                                showConfirmationDialog();
                              },
                            ),
                          )
                        ])),
          ],
        ),
      ),
    );
  }
}
