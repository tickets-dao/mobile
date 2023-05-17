import 'package:dao_ticketer/backend_service/real_implementations/local_store_service.dart';
import 'package:dao_ticketer/screens/home.dart';
import 'package:dao_ticketer/backend_service/real_implementations/dao_service.impl.dart';
import 'package:dao_ticketer/types/route_names.dart';
import 'package:dao_ticketer/types/screen_arguments.dart';
import 'package:flutter/material.dart';

class AssetFileSelectionWidget extends StatefulWidget {
  const AssetFileSelectionWidget({super.key});

  @override
  _AssetFileSelectionWidgetState createState() =>
      _AssetFileSelectionWidgetState();
}

class _AssetFileSelectionWidgetState extends State<AssetFileSelectionWidget> {
  List<String> files = [];

  late DAOLocalStoreService lsService;
  late RealDAOService service;

  // todo create map to display nice roles, and not filenames
  Map<String, String> filesMap = {};
  String _selectedOption = "";

  loadAssetFileList() async {
    List<String> loadedPaths = await lsService.loadKeyFiles();

    setState(() {
      files = loadedPaths;
    });
  }

  @override
  void initState() {
    super.initState();

    // these calls to the service constructors are the first ones in the
    // life cycle of the application, so they will instantiate the singletons
    lsService = DAOLocalStoreService();
    service = RealDAOService(true);
    // lsService.loadKeyFiles();
    loadAssetFileList();
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
