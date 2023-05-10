import 'package:flutter/material.dart';

class CategoriesEditor extends StatefulWidget {
  const CategoriesEditor(
      {required value, required onChanged, fixCategoryKeys = false, super.key});

  final Map<String, int> value;
  Map<String, int> onChanged(Map<String, int> value) => value;
  final bool fixCategoryKeys;

  @override
  State<CategoriesEditor> createState() => _CategoriesEditorState();
}

class _CategoriesEditorState extends State<CategoriesEditor> {
  void onChanged;
  Map<String, int> categoriesMap = {};

  @override
  Widget build(BuildContext context) {
    // TODO: implement build of input pairs where the key is for the category name and the value is for the price
    throw UnimplementedError();
  }
}
