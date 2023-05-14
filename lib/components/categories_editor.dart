import 'package:dao_ticketer/types/price_category.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class CategoriesEditor extends StatefulWidget {
  const CategoriesEditor(
      {required this.value,
      required onChanged,
      this.fixCategoryKeys = false,
      super.key});

  final List<PriceCategory> value;

  List<PriceCategory> onChanged(List<PriceCategory> value) => value;
  final bool fixCategoryKeys;

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
    List<Widget> res = editableValue
        .map(
          (e) => Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), label: Text("cat. name")),
                    onChanged: (newName) {
                      e.setName(newName);
                      syncWithParent();
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), label: Text("price")),
                    onChanged: (newPrice) {
                      e.setPrice(int.parse(newPrice));
                      syncWithParent();
                    },
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    int index = editableValue.indexOf(e);
                    setState(() {
                      editableValue.removeAt(index);
                    });
                  },
                  child: const Text("Delete"))
            ],
          ),
        )
        .toList();
    res.add(Row(
      children: [
        ElevatedButton(
            onPressed: () {
              setState(() {
                editableValue.add(Entry(key_: "", value_: 0));
              });
            },
            child: const Text("+ add category"))
      ],
    ));
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
