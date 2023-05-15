import 'package:dao_ticketer/backend_service/real_implementations/dao_service.impl.dart';
import 'package:dao_ticketer/types/price_category.dart';
import 'package:flutter/material.dart';
import 'package:dao_ticketer/types/event.dart';
import 'package:dao_ticketer/components/event_card.dart';
import 'package:dao_ticketer/components/categories_editor.dart';

class IssuerEventScreen extends StatefulWidget {
  const IssuerEventScreen({this.event, this.eventID, super.key});

  final Event? event;
  final String? eventID;

  @override
  State<IssuerEventScreen> createState() => _IssuerEventScreenState();
}

class _IssuerEventScreenState extends State<IssuerEventScreen> {
  Event event = Event.emptyFallback();
  List<PriceCategory> categories = [];
  RealDAOService service = RealDAOService.getSingleton();

  void initEventData() async {
    if (widget.event == null) {
      List<Event> respEvents = await service
          .getEventsByID([widget.eventID ?? "uninitialized event ID"]);
      event = respEvents[0];
    } else {
      event = widget.event ?? Event.emptyFallback();
    }
    service
        .getIssuerEventCategories(widget.event?.id ?? "uninitialized event ID")
        .then((cs) {
      setState(() {
        categories = cs;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initEventData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            EventCard(event, false),
            Expanded(
              child: CategoriesEditor(
                value: categories,
                onChanged: (value) {
                  setState(() {
                    categories = value;
                  });
                },
                pricesOnly: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
