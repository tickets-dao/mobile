import 'package:dao_ticketer/types/price_category.dart';
import 'package:flutter/material.dart';
// import 'dart:async';

class CategoriesEditor extends StatefulWidget {
  const CategoriesEditor(
      {required this.value,
      required this.onChanged,
      this.pricesOnly = false,
      super.key});

  final List<PriceCategory> value;

  final Function onChanged;
  final bool pricesOnly;

  @override
  State<CategoriesEditor> createState() => _CategoriesEditorState();
}

class _CategoriesEditorState extends State<CategoriesEditor> {
  List<PriceCategory> editableValue = [];

  // Timer? _debounce;

  @override
  void initState() {
    super.initState();
    setState(() {
      editableValue = widget.value;
    });
  }

  syncWithParent() {
    // if (_debounce?.isActive ?? false) _debounce?.cancel();
    // _debounce = Timer(const Duration(milliseconds: 500), () {
    widget.onChanged(editableValue);
    // });
  }

  getTextFieldOrInput(PriceCategory e) {
    return widget.pricesOnly
        ? Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
            child: Text("Категория: ${e.name}",
                style: const TextStyle(fontSize: 18)),
          )
        : Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Название категории")),
                    onChanged: (newName) {
                      e.setName(newName);
                      syncWithParent();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      int index = editableValue.indexOf(e);
                      setState(() {
                        editableValue.removeAt(index);
                      });
                      syncWithParent();
                    },
                  ),
                )
              ],
            ),
          );
  }

  getRowsSeatsEditors(PriceCategory e) {
    return widget.pricesOnly
        ? []
        : [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Количество рядов")),
                onChanged: (newRows) {
                  if (newRows != "") {
                    e.setRows(int.parse(newRows));
                    syncWithParent();
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Количество мест")),
                onChanged: (newSeats) {
                  if (newSeats != "") {
                    e.setSeats(int.parse(newSeats));
                    syncWithParent();
                  }
                },
              ),
            ),
          ];
  }

  List<Widget> getEntriesUIwithButton() {
    List<Widget> res = [
      ...editableValue.map(
        (e) => Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            getTextFieldOrInput(e),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: TextField(
                  controller: TextEditingController(text: "${e.price}"),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), label: Text("Цена")),
                  onSubmitted: (newPrice) {
                    // Check if the input is a valid number
                    var tryParsePrice = int.tryParse(newPrice);
                    if (tryParsePrice != null) {
                      e.setPrice(tryParsePrice);
                      syncWithParent();
                    }
                  },
                  onTapOutside: (event) {
                    syncWithParent();
                  }),
            ),
            ...getRowsSeatsEditors(e),
          ],
        ),
      )
    ];

    if (!widget.pricesOnly) {
      Widget addCategoryButton = ElevatedButton(
          onPressed: () {
            setState(() {
              editableValue.add(
                  PriceCategory(name: "", price: 200, rows: 10, seats: 10));
            });
          },
          child: const Text("+ добавить категорию"));
      res.add(addCategoryButton);
    }
    res.add(
      const Divider(),
    );
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: getEntriesUIwithButton(),
    );
  }
}
