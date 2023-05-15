import 'package:dao_ticketer/screens/home.dart';
import 'package:dao_ticketer/backend_service/real_implementations/dao_service.impl.dart';
import 'package:dao_ticketer/types/route_names.dart';
import 'package:dao_ticketer/types/screen_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class AssetFileSelectionWidget extends StatefulWidget {
  const AssetFileSelectionWidget({super.key});

  @override
  _AssetFileSelectionWidgetState createState() =>
      _AssetFileSelectionWidgetState();
}

class _AssetFileSelectionWidgetState extends State<AssetFileSelectionWidget> {
  List<String> files = [];

  // todo create map to display nice roles, and not filenames
  Map<String, String> filesMap = {};
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

    // this call to the service constructor is the first one in the
    // life cycle of the application, so it will instantiate the singleton
    RealDAOService service = RealDAOService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select the user')),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
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

                  Navigator.pushNamed(context, AppRouteName.home,
                      arguments: HomeScreenArguments(_selectedOption));
                },
                child: const Text('Confirm'),
              ),
            ],
          )),
    );
  }
}
