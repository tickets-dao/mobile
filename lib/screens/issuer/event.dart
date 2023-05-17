import 'package:dao_ticketer/backend_service/real_implementations/dao_service.impl.dart';
import 'package:dao_ticketer/types/price_category.dart';
import 'package:dao_ticketer/types/route_names.dart';
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
  List<String> ticketers = [];
  bool pricesChanged = false;

  String newTicketerAddr = "";
  RealDAOService service = RealDAOService.getSingleton();

  void initEventData() async {
    if (widget.event == null) {
      List<Event> respEvents = await service
          .getEventsByID([widget.eventID ?? "uninitialized event ID"]);
      event = respEvents[0];
    } else {
      event = widget.event ?? Event.emptyFallback();
    }
    List<PriceCategory> cs = await service
        .getIssuerEventCategories(widget.event?.id ?? "uninitialized event ID");
    setState(() {
      categories = cs;
    });

    // Future<void> addTicketer(String ticketerAddress);

    List<String> ttrs = await service.getTicketers();

    setState(() {
      ticketers = ttrs;
    });
  }

  @override
  void initState() {
    super.initState();
    initEventData();
  }

  addTicketer(String ttrToAdd) async {
    bool resp = await service.addTicketer(ttrToAdd);
    if (resp) {
      ticketers = [...ticketers, ttrToAdd];
    }
    newTicketerAddr = "";
  }

  deleteTicketer(String ttrToDelete) async {
    bool resp = await service.deleteTicketer(ttrToDelete);
    if (resp) {
      setState(() {
        ticketers = [...ticketers.where((String ttr) => ttr != ttrToDelete)];
      });
    }
  }

  List<Widget> renderCategoriesEditor() {
    return categories.isNotEmpty
        ? [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: CategoriesEditor(
                value: categories,
                onChanged: (value) {
                  setState(() {
                    categories = value;
                    pricesChanged = true;
                  });
                },
                pricesOnly: true,
              ),
            )
          ]
        : [];
  }

  List<Widget> getTicketerInputs() {
    return ticketers.isNotEmpty
        ? [
            const Text("Ticketers",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ...ticketers.map((String ttr) => Padding(
                padding: const EdgeInsets.all(5),
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ttr),
                    IconButton(
                        onPressed: () {
                          deleteTicketer(ttr);
                        },
                        icon: const Icon(Icons.delete_outline))
                  ],
                ))),
            Padding(
                padding: const EdgeInsets.all(5),
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                          label: Text("Ticketer address")),
                      onChanged: (value) {
                        newTicketerAddr = value;
                      },
                    ),
                    IconButton(
                        onPressed: () {
                          addTicketer(newTicketerAddr);
                        },
                        icon: const Icon(Icons.add_circle_outline))
                  ],
                ))
          ]
        : [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Flex(
                    direction: Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Text>[
                      Text(event.name),
                      Text(event.address),
                    ]),
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("Update category prices",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              ...renderCategoriesEditor(),
              ...getTicketerInputs(),
            ],
          ),
        ),
      ),
      floatingActionButton: pricesChanged
          ? ElevatedButton(
              onPressed: () {
                service.setCategoryPrices(event.id, categories);
              },
              child: const Text("Save price updates"),
            )
          : null,
    );
  }
}
