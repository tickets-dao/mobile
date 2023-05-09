import 'package:dao_ticketer/backend_service/real_implementations/dao_service.impl.dart';
import 'package:flutter/material.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});

  @override
  BalanceScreenState createState() => BalanceScreenState();
}

class BalanceScreenState extends State<BalanceScreen> {
  int balance = -1;
  RealDAOService service = RealDAOService.getSingleton();

  getUserBalance() {
    service.getUserBalance().then((int b) {
      setState(() {
        balance = b;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUserBalance();
  }

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your balance')),
      body: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Your current balance is $balance"),
          ElevatedButton(
              onPressed: () {
                service.addFunds().then((_) {
                  getUserBalance();
                });
              },
              child: const Text("Add funds"))
        ],
      ),
    );
  }
}
