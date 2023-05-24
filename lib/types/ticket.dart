import 'dart:convert';

class Ticket {
  late final String category;
  late final int price;
  late final int row;
  late final int number;
  late final String eventID;

  Ticket(this.category, this.price, this.row, this.number, this.eventID);

  factory Ticket.emptyPlug() {
    return Ticket("no category", -1, -1, -1, "no event");
  }

  Ticket.fromJson(Map<String, dynamic> json)
      : category = json['category'],
        price = json['price'],
        row = json['row'],
        number = json['number'],
        eventID = json['event_id'];

  Map<String, dynamic> toJson() => {
        'category': category,
        'price': price,
        'row': row,
        'number': number,
        'event_id': eventID
      };
}

List<Ticket> parseTickets(String jsonString) {
  final parsedList = jsonDecode(jsonString) as List<dynamic>;
  return parsedList
      .map((e) => Ticket.fromJson(e as Map<String, dynamic>))
      .toList();
}
