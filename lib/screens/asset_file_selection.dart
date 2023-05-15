import 'package:dao_ticketer/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class AssetFileSelectionWidget extends StatefulWidget {
  @override
  _AssetFileSelectionWidgetState createState() =>
      _AssetFileSelectionWidgetState();
}

class _AssetFileSelectionWidgetState extends State<AssetFileSelectionWidget> {
  List<String> files = [];
  String _selectedOption = "";

  @override
  void initState() {
    super.initState();
    loadAssetFileList();
  }

  Future<void> loadAssetFileList() async {
    // Load asset manifest
    final String manifestContent =
    await rootBundle.loadString('AssetManifest.json');

    // Decode it to JSON
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // Get list of all asset paths
    final List<String> paths = manifestMap.keys
        .where((String key) => key.startsWith('assets/'))
        .toList();

    setState(() {
      files = paths;
    });
  }

  void fileTapped(String filename) {
    print("Selected File: $filename");
    // Here you can handle the selected file and initialize your app
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
        child: Column(
          children: <Widget>[
            ...files.map((option) {
              return ListTile(
                title: Text(option),
                leading: Radio<String>(
                  value: option,
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value!;
                    });
                  },
                ),
              );
            }).toList(),
            ElevatedButton(
              onPressed: () {
                print('Selected option: $_selectedOption');

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HomeScreen(
                                key: Key("aaaa"),
                                selectedFile: _selectedOption)));
              },
              child: const Text('Confirm'),
            ),
          ],
        ));
  }
}
