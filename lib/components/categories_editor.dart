import 'package:flutter/material.dart';
import 'dart:async';

class Entry {
  Entry({this.key_ = "", this.value_ = -1});

  String key_;
  int value_;

  String get key => key_;
  int get value => value_;

  void setKey(newKey) {
    key_ = newKey;
  }

  void setValue(newValue) {
    value_ = newValue;
  }
}

class CategoriesEditor extends StatefulWidget {
  CategoriesEditor(
      {required this.value,
      required onChanged,
      this.fixCategoryKeys = false,
      super.key});

  final Map<String, int> value;

  Map<String, int> onChanged(Map<String, int> value) => value;
  final bool fixCategoryKeys;

  @override
  State<CategoriesEditor> createState() => _CategoriesEditorState();
}

class _CategoriesEditorState extends State<CategoriesEditor> {
  void onChanged;
  Map<String, int> categoriesMap = {};
  List<Entry> editableValue = [];

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    editableValue = [
      ...widget.value.entries.map((e) => Entry(key_: e.key, value_: e.value))
    ];
  }

  listToMap(List<Entry> list) {
    const res = {};
    for (Entry e in list) {
      res.addAll({e.key: e.value});
    }
    return res;
  }

  syncWithParent() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onChanged(listToMap(editableValue));
    });
  }

  List<Widget> getEntriesUIwithButton() {
    print('categories editor: editableValue: $editableValue');
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
                    onChanged: (newKey) {
                      e.setKey(newKey);
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
                    onChanged: (newValue) {
                      e.setValue(newValue);
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
