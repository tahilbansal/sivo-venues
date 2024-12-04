import 'dart:convert';

List<Item> itemFromJson(String str) => List<Item>.from(json.decode(str).map((x) => Item.fromJson(x)));

String itemToJson(List<Item> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Item {
  final String id;
  final String title;
  final List<String> itemTags;
  final String code;
  final bool isAvailable;
  final String supplier;
  final String description;
  final double? price;
  final List<String>? imageUrl;
  final int v;
  final String category;

  Item({
    required this.id,
    required this.title,
    required this.itemTags,
    required this.code,
    required this.isAvailable,
    required this.supplier,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.v,
    required this.category,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["_id"],
        title: json["title"],
        itemTags: List<String>.from(json["itemTags"].map((x) => x)),
        code: json["code"],
        isAvailable: json["isAvailable"],
        supplier: json["supplier"],
        description: json["description"],
        price: json["price"]?.toDouble(),
        imageUrl: List<String>.from(json["imageUrl"].map((x) => x)),
        v: json["__v"],
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "itemTags": List<dynamic>.from(itemTags.map((x) => x)),
    "code": code,
    "isAvailable": isAvailable,
    "supplier": supplier,
    "description": description,
    "price": price,
    "imageUrl": imageUrl != null
        ? List<dynamic>.from(imageUrl!.map((x) => x))
        : null,
    "__v": v,
    "category": category
  };
}

// class Additive {
//   final int id;
//   final String title;
//   final String price;
//
//   Additive({
//     required this.id,
//     required this.title,
//     required this.price,
//   });
//
//   factory Additive.fromJson(Map<String, dynamic> json) => Additive(
//         id: json["id"],
//         title: json["title"],
//         price: json["price"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "title": title,
//         "price": price,
//       };
// }
