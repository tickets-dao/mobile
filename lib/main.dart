import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'package:provider/provider.dart';

import 'package:dao_ticketer/backend_service/real_implementations/dao_service.impl.dart'
    show RealDAOService;

class TicketerDAO extends StatelessWidget {
  const TicketerDAO({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeScreen());
  }
}

void main() {
  runApp(Provider(create: (_) => RealDAOService(), child: const TicketerDAO()));
}
