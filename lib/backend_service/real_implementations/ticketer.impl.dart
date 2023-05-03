import 'dart:math';

import '../../types/ticket.dart';

class Ticketer {
  //
  Future<void> burnTicket(Ticket ticket, String secret) async {
    if (Random().nextInt(10) > 7) {
      throw "try again";
    }

    return Future.delayed(const Duration(seconds: 1));
  }
}
