import 'package:dao_ticketer/screens/user_selection.dart';
import 'routes.dart';
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
      routes: appRoutes,
      home: const UserSelectionWidget(),
    );
  }
}

void main() {
  runApp(const TicketerDAO());
}
