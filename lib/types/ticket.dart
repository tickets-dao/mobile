import 'dart:convert';

class Ticket {
  late final String category;
  late final int price;
  late final int sector;
  late final int row;
  late final int number;
  late final String eventID;

  Ticket(this.category, this.price, this.sector, this.row, this.number,
      this.eventID);

  Ticket.fromJson(Map<String, dynamic> json)
      : category = json['category'],
        price = json['price'],
        sector = json['sector'],
        row = json['row'],
        number = json['number'],
        eventID = json['event_id'];
}

List<Ticket> parseTickets(String jsonString) {
  final parsedList = jsonDecode(jsonString) as List<dynamic>;
  return parsedList
      .map((e) => Ticket.fromJson(e as Map<String, dynamic>))
      .toList();
}
