import 'package:dao_ticketer/backend_service/real_implementations/dao_service.impl.dart';
import 'package:dao_ticketer/types/price_category.dart';
import 'package:flutter/material.dart';
import 'package:dao_ticketer/types/event.dart';
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
    await service.addTicketer(ttrToAdd);

    setState(() {
      newTicketerAddr = ttrToAdd;
      ticketers = [...ticketers, ttrToAdd];
    });
  }

  deleteTicketer(String ttrToDelete) async {
    await service.deleteTicketer(ttrToDelete);
    setState(() {
      ticketers = [...ticketers.where((String ttr) => ttr != ttrToDelete)];
    });
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
                    for (int ind
                        in List.generate(categories.length, (ind) => ind)) {
                      if (categories[ind].price != value[ind].price) {
                        pricesChanged = true;
                        break;
                      }
                    }
                  });
                },
                pricesOnly: true,
              ),
            )
          ]
        : [];
  }

  Widget getTicketerInputs() {
    return Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 10),
            child: Text(
                ticketers.isNotEmpty ? "Биллетеры" : "Биллетеры не добавлены ",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          ...ticketers.map((String ttr) => Padding(
              padding: const EdgeInsets.all(5),
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 285,
                    child: Text(
                      ttr,
                      maxLines: 3,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        deleteTicketer(ttr);
                      },
                      icon: const Icon(Icons.delete_outline)),
                ],
              ))),
          Padding(
              padding: const EdgeInsets.all(5),
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                          label: Text("Идентификатор биллетера"),
                          border: OutlineInputBorder()),
                      onChanged: (value) {
                        newTicketerAddr = value;
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        if (newTicketerAddr == "") return;
                        addTicketer(newTicketerAddr);
                      },
                      icon: const Icon(Icons.save_outlined))
                ],
              )),
          Padding(
              padding: const EdgeInsets.all(5),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    ticketers.add("");
                  });
                },
                child: const Text("Добавить"),
              ))
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мероприятие')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: Flex(
                    direction: Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Text(event.name,
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold)),
                      ),
                      Text(event.address),
                    ]),
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("Обновить цены категорий",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              ...renderCategoriesEditor(),
              getTicketerInputs(),
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
