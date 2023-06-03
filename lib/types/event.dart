import 'dart:convert';

class Event {
  final DateTime startTime;
  final String address;
  final String name;
  final String id;
  bool? passed = false;

  Event(this.startTime, this.address, this.name, this.id);

  Event.fromJson(Map<String, dynamic> json)
      : startTime = DateTime.parse(json['start_time']).toLocal(),
        address = json['address'],
        name = json['name'],
        id = json['id'];

  factory Event.emptyFallback() {
    return Event(DateTime.now(), "no address", "idk, man", "lol");
  }
}

List<Event> parseEvents(String jsonString) {
  if (jsonString == "null") {
    return [];
  }

  final parsedList = jsonDecode(jsonString) as List<dynamic>;
  return parsedList
      .map((e) => Event.fromJson(e as Map<String, dynamic>))
      .toList();
}
