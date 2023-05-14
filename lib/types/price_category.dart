import 'dart:convert';

class PriceCategory {
  PriceCategory({
    required this.name,
    required this.price,
    required this.rows,
    required this.seats,
  });

  String name;
  int price;
  int rows;
  int seats;

  void setName(String newName) {
    name = newName;
  }

  void setPrice(int newPrice) {
    price = newPrice;
  }

  void setRows(int newRows) {
    rows = newRows;
  }

  void newSeats(newSeats) {
    seats = newSeats;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'rows': rows,
        'seats': seats,
      };
  PriceCategory.fromJson(Map<String, dynamic> json)
      : price = int.parse(json['price'].replaceAll('"', '')),
        name = json['name'],
        rows = json['rows'],
        seats = json['seats'];
}

Map<String, PriceCategory> priceCategoryFromJson(String str) {
  final List<dynamic> jsonData = jsonDecode(str);
  return {
    for (var item in jsonData) item['name']: PriceCategory.fromJson(item)
  };
}
