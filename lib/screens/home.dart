import 'package:flutter/material.dart';
import 'package:dao_ticketer/backend_service/real_implementations/dao_service.impl.dart'
    show RealDAOService;

import 'package:dao_ticketer/types/route_names.dart';

ListView getDrawerItems(BuildContext context) => ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Сменить пользователя'),
                IconButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, AppRouteName.userSelect);
                    },
                    icon: const Icon(Icons.logout_outlined))
              ],
            ),
          ),
          ListTile(
              title: const Text('Баланс'),
              onTap: () {
                Navigator.pushNamed(context, AppRouteName.userBalance);
              }),
          ListTile(
              title: const Text('Мои билеты'),
              onTap: () {
                Navigator.pushNamed(context, AppRouteName.userTickets);
              }),
          ListTile(
            title: const Text('Покупатель: мероприятия'),
            onTap: () {
              Navigator.pushNamed(context, AppRouteName.customerEvents);
            },
          ),
          ListTile(
              title: const Text('Организатор: мероприятия'),
              onTap: () {
                Navigator.pushNamed(context, AppRouteName.issuerEventList);
              }),
          ListTile(
              title: const Text('Биллетер: отсканировать QR'),
              onTap: () {
                Navigator.pushNamed(context, AppRouteName.ticketerScan);
              }),
        ]);

class HomeScreen extends StatefulWidget {
  final String selectedFile;

  const HomeScreen({required this.selectedFile, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String get selectedFile => widget.selectedFile;
  RealDAOService service = RealDAOService.getSingleton();

  @override
  void initState() {
    super.initState();
    print("selected file: $selectedFile");

    // for local chaincode use
    // RealDAOService service = RealDAOService(true);

    service.init(selectedFile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('DAO билетошная'),
      ),
      drawer: Drawer(
        child: getDrawerItems(context),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const <Widget>[],
      )),
    );
  }
}
