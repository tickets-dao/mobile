import 'package:dao_ticketer/types/price_category.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class CategoriesEditor extends StatefulWidget {
  const CategoriesEditor(
      {required this.value,
      required onChanged,
      this.pricesOnly = false,
      super.key});

  final List<PriceCategory> value;

  List<PriceCategory> onChanged(List<PriceCategory> value) => value;
  final bool pricesOnly;

  @override
  State<CategoriesEditor> createState() => _CategoriesEditorState();
}

class _CategoriesEditorState extends State<CategoriesEditor> {
  void onChanged;
  Map<String, int> categoriesMap = {};
  List<PriceCategory> editableValue = [];

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    editableValue = [...widget.value];
  }

  syncWithParent() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onChanged(editableValue);
    });
  }

  List<Widget> getEntriesUIwithButton() {
    List<Widget> res = [
      ...editableValue.map(
        (e) => Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Cat. name")),
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
                      },
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), label: Text("Price")),
                onChanged: (newPrice) {
                  e.setPrice(int.parse(newPrice));
                  syncWithParent();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), label: Text("Rows")),
                onChanged: (newRows) {
                  e.setRows(int.parse(newRows));
                  syncWithParent();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), label: Text("Seats")),
                onChanged: (newSeats) {
                  e.setSeats(int.parse(newSeats));
                  syncWithParent();
                },
              ),
            ),
            const Divider(),
          ],
        ),
      )
    ];

    Widget addCategoryButton = ElevatedButton(
        onPressed: () {
          setState(() {
            editableValue
                .add(PriceCategory(name: "", price: 200, rows: 10, seats: 10));
          });
        },
        child: const Text("+ add category"));
    res.add(addCategoryButton);
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
