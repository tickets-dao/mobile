import 'package:dao_ticketer/backend_service/real_implementations/local_store_service.impl.dart';
import 'package:dao_ticketer/backend_service/real_implementations/dao_service.impl.dart';
import 'package:dao_ticketer/types/route_names.dart';
import 'package:dao_ticketer/types/screen_arguments.dart';
import 'package:dao_ticketer/types/user.dart' show DAOUser;
import 'package:flutter/material.dart';

class UserSelectionWidget extends StatefulWidget {
  const UserSelectionWidget({super.key});

  @override
  UserSelectionWidgetState createState() => UserSelectionWidgetState();
}

class UserSelectionWidgetState extends State<UserSelectionWidget> {
  List<String> files = [];

  late DAOLocalStoreService lsService;
  late RealDAOService service;

  String _selectedUserOption = "";
  String newUserAddr = "";
  String newUserName = "";

  late List<DAOUser> localUsers;

  loadLocalUsers() {
    setState(() {
      localUsers = lsService.getLocalySavedUsers();
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
    loadLocalUsers();
  }

  getLocalUsers() {
    return localUsers.isNotEmpty
        ? [
            ...localUsers.map((DAOUser savedUser) {
              return ListTile(
                title: Text(savedUser.name),
                leading: Radio<String>(
                  value: savedUser.secret,
                  groupValue: _selectedUserOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedUserOption = value!;
                    });
                  },
                ),
              );
            })
          ]
        : [const Text("No saved users, plz add one below")];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select the user')),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: Column(
              children: [
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ...getLocalUsers(),
                      _selectedUserOption != ""
                          ? ElevatedButton(
                              onPressed: () {
                                print('Selected option: $_selectedUserOption');

                                Navigator.pushNamed(context, AppRouteName.home,
                                    arguments: HomeScreenArguments(
                                        _selectedUserOption));
                              },
                              child: const Text('Confirm'),
                            )
                          : Container(),
                    ],
                  ),
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
                            lsService
                                .addUserSecret(newUserAddr, newUserName)
                                .then((res) {
                              setState(() {
                                localUsers = lsService.getLocalySavedUsers();
                              });
                            });
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
