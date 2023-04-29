import 'package:flutter/material.dart';
import 'screens/home.dart';

class TicketerDAO extends StatelessWidget {
  const TicketerDAO({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeScreen());
  }
}

void main() {
  runApp(const TicketerDAO());
}
