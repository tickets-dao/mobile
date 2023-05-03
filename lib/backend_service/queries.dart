import 'dart:ffi';
import 'dart:math';

class Event {
  final DateTime startTime;
  final String address;
  final String name;
  final String id;

  Event(this.startTime, this.address, this.name, this.id);
}

Future<List<Event>> getShows() async {
  return Future.delayed(Duration(seconds: 1),
      () => [Event(DateTime.now(), "YoY address", "lebedinoe ozero", "123")]);
}

class Ticket {
  final String category;
  final int price;
  final int sector;
  final int row;
  final int number;
  final String eventID;

  Ticket(this.category, this.price, this.sector, this.row, this.number,
      this.eventID);
}

Future<List<String>> getCategories() async {
  return Future.delayed(Duration(seconds: 1), () => ["parter", "lozha"]);
}

Future<int> getBalance() async {
  return Future.delayed(Duration(seconds: 1), () => 10000);
}

Future<List<Ticket>> listTicketsByEventCategory(
    String eventID, String category) async {
  return Future.delayed(
      Duration(seconds: 1), () => [Ticket(category, 1000, 1, 1, 1, "123")]);
}

Future<List<Ticket>> listMyTickets() async {
  return Future.delayed(
      Duration(seconds: 1), () => [Ticket("parter", 1000, 1, 1, 1, "123")]);
}


Future<void> buyTicket(Ticket ticket) async {
  if (Random().nextInt(10) > 5) {
    throw "try again";
  }

  return Future.delayed(Duration(seconds: 1));
}


Future<void> returnTicket(Ticket ticket) async {
  if (Random().nextInt(10) > 5) {
    throw "try again";
  }

  return Future.delayed(Duration(seconds: 1));
}

Future<void> prepareTicket(Ticket ticket, String secret) async {
  if (Random().nextInt(10) > 5) {
    throw "try again";
  }

  // hash(secret) -> blockchain
  // blockchain.save()

  return Future.delayed(Duration(seconds: 1));
}


