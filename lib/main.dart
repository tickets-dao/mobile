import 'package:dao_ticketer/screens/asset_file_selection.dart';
import 'package:flutter/material.dart';

class TicketerDAO extends StatelessWidget {
  const TicketerDAO({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(body: AssetFileSelectionWidget()),
    );
  }
}

void main() {
  runApp(const TicketerDAO());
}
