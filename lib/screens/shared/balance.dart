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
      appBar: AppBar(title: const Text('Wallet')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Your current balance: $balance",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: ElevatedButton(
                  onPressed: () {
                    service.addFunds().then((_) {
                      getUserBalance();
                    });
                  },
                  child: const Text("Add funds")),
            )
          ],
        ),
      ),
    );
  }
}
