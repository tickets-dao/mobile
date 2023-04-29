import 'dart:math';

class Ticketer{
  //
  Future<void> burnTicket(Ticket ticket, String secret) async {
    if (Random().nextInt(10) > 5) {
      throw "try again";
    }

    return Future.delayed(Duration(seconds: 1));
  }

}