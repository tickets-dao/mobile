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

  PriceCategory.fromJson(Map<String, dynamic> json)
      : price = int.parse(json['price'].replaceAll('"', '')),
        name = json['name'],
        rows = json['rows'],
        seats = json['seats'];
}

Map<String, PriceCategory> priceCategoryFromJson(String str) {
  final List<dynamic> jsonData = jsonDecode(str);
  return {for (var item in jsonData) item['name']: PriceCategory.fromJson(item)};
}
