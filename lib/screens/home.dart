import 'package:flutter/material.dart';
import 'package:dao_ticketer/screens/customer/event_list.dart';
import 'scan-qr.dart';
import 'render-qr.dart';

void navigateTo(BuildContext context, String screen) {
  switch (screen) {
    case "events":
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const EventsListScreen()));
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
            title: const Text("Events"),
            onTap: () {
              navigateTo(ctx, "events");
            },
          ),
          ListTile(
            title: const Text("Generate QR"),
            onTap: () {
              navigateTo(ctx, "generate");
            },
          ),
          ListTile(
            title: const Text("Scan QR"),
            onTap: () {
              navigateTo(ctx, "scan");
            },
          ),
        ]);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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