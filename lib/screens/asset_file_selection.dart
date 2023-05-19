import 'package:dao_ticketer/backend_service/real_implementations/local_store_service.impl.dart';
import 'package:dao_ticketer/backend_service/real_implementations/dao_service.impl.dart';
import 'package:dao_ticketer/types/route_names.dart';
import 'package:dao_ticketer/types/screen_arguments.dart';
import 'package:dao_ticketer/types/user.dart' show DAOUser;
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
  String newUserAddr = "";
  String newUserName = "";

  late final List<DAOUser> localUsers;

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
    DAOLocalStoreService();
    lsService = DAOLocalStoreService.getSingleton();
    service = RealDAOService();
    // lsService.loadKeyFiles();
    loadAssetFileList();
    localUsers = lsService.getLocalySavedUsers();

    for (DAOUser localUser in localUsers) {
      print(
          'loaded local user: ${localUser.name}, secret: ${localUser.secret}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select the user')),
      body: SingleChildScrollView(
        child: Padding(
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
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 211, 228, 239),
                        spreadRadius: 5,
                        blurRadius: 7,
                      ),
                    ],
                  ),
                  child: Flex(
                    direction: Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Text("Add new user",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: TextField(
                          decoration: const InputDecoration(
                            label: Text("Username/role"),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            newUserName = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: TextField(
                          decoration: const InputDecoration(
                            label: Text("Paste secret here"),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            newUserAddr = value;
                          },
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            lsService.addUserSecret(newUserAddr, newUserName);
                          },
                          child: const Text("Add"))
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
