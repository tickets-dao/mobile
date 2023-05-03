import 'dart:convert';

class Event {
  final DateTime startTime;
  final String address;
  final String name;
  final String id;

  Event(this.startTime, this.address, this.name, this.id);

  Event.fromJson(Map<String, dynamic> json)
      : startTime = DateTime.parse(json['start_time']),
        address = json['address'],
        name = json['name'],
        id = json['id'];
}

List<Event> parseEvents(String jsonString) {
  final parsedList = jsonDecode(jsonString) as List<dynamic>;
  return parsedList.map((e) => Event.fromJson(e as Map<String, dynamic>)).toList();
}