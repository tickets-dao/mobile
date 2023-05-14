import 'package:dao_ticketer/screens/customer/balance.dart';
import 'package:flutter/material.dart';
import 'package:dao_ticketer/backend_service/real_implementations/dao_service.impl.dart'
    show RealDAOService;
import 'package:dao_ticketer/screens/customer/event_list.dart'
    show EventsListScreen;
import 'package:dao_ticketer/screens/issuer/event_list.dart'
    show IssuerEventsListScreen;
import 'package:dao_ticketer/screens/customer/tickets_list.dart'
    show TicketListScreen;
import 'ticketer/scan_qr.dart';
import 'customer/render_qr.dart';

void navigateTo(BuildContext context, String screen) {
  switch (screen) {
    case "events":
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const EventsListScreen()));
      break;
    case "tickets":
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const TicketListScreen()));
      break;
    case "balance":
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const BalanceScreen()));
      break;
    case "emittentEvents":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const IssuerEventsListScreen()),
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
              title: const Text('Your balance'),
              onTap: () {
                navigateTo(ctx, 'balance');
              }),
          ListTile(
              title: const Text('issuer: Events'),
              onTap: () {
                navigateTo(ctx, 'emittentEvents');
              }),
        ]);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // this call to the service constructor is the first one in the
    // life cycle of the application, so it will instantiate the singleton
    // RealDAOService service = RealDAOService();

    // for local chaincode use
    RealDAOService service = RealDAOService(true);

    service.init('assets/keys/user.private');
  }

  @override
  Widget build(BuildContext context) {
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
        ],
      )),
    );
  }
}
