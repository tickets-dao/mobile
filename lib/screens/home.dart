import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dao_ticketer/backend_service/real_implementations/dao_service.impl.dart'
    show RealDAOService;
import 'package:dao_ticketer/screens/customer/event_list.dart'
    show EventsListScreen;
import 'package:dao_ticketer/screens/customer/tickets_list.dart'
    show TicketListScreen;
import 'scan-qr.dart';
import 'render-qr.dart';

void navigateTo(BuildContext context, String screen) {
  switch (screen) {
    case "events":
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const EventsListScreen()));
      break;
    case "tickets":
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => TicketListScreen()));
      break;
    case "scan":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ScanScreen()),
      );
      break;
    case "generate":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GenerateScreen()),
      );
      break;
    default:
      return;
  }
}

ListView getDrawerItems(BuildContext ctx) => ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Ticketer Menu'),
          ),
          ListTile(
            title: const Text('Events'),
            onTap: () {
              navigateTo(ctx, 'events');
            },
          ),
          ListTile(
              title: const Text('Your tickets'),
              onTap: () {
                navigateTo(ctx, 'tickets');
              }),
          ListTile(
            title: const Text('Generate QR'),
            onTap: () {
              navigateTo(ctx, 'generate');
            },
          ),
          ListTile(
            title: const Text('Scan QR'),
            onTap: () {
              navigateTo(ctx, 'scan');
            },
          ),
        ]);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RealDAOService service = RealDAOService();

  @override
  Widget build(BuildContext context) {
    context.read<RealDAOService>().init('assets/keys/user.private');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('DAO ticketer'),
      ),
      drawer: Drawer(
        child: getDrawerItems(context),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ScanScreen()),
                  );
                },
                child: const Text('SCAN QR CODE')),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GenerateScreen()),
                  );
                },
                child: const Text('GENERATE QR CODE')),
          ),
        ],
      )),
    );
  }
}
