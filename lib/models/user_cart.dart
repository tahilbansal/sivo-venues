// To parse this JSON data, do
//
//     final userCart = userCartFromJson(jsonString);

import 'dart:convert';
import 'package:rivus_user/models/items.dart';

List<UserCart> userCartFromJson(String str) =>
    List<UserCart>.from(json.decode(str).map((x) => UserCart.fromJson(x)));

String userCartToJson(List<UserCart> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserCart {
  final String id;
  final String userId;
  final String supplierId;
  final List<CartItem> items;
  final double grandTotal;

  UserCart({
    required this.id,
    required this.userId,
    required this.supplierId,
    required this.items,
    required this.grandTotal,
  });

  factory UserCart.fromJson(Map<String, dynamic> json) => UserCart(
      id: json["_id"],
      userId: json["userId"],
      supplierId: json["supplierId"],
      items: List<CartItem>.from(json["items"].map((x) => CartItem.fromJson(x))),
      grandTotal: json["grandTotal"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "supplierId": supplierId,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "grandTotal": grandTotal,
  };
}

class CartItem {
  final ProductId productId;
  final int quantity;
  final double totalPrice;

  CartItem({
    required this.productId,
    required this.quantity,
    required this.totalPrice,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    productId: ProductId.fromJson(json["productId"]),
    quantity: json["quantity"],
    totalPrice: json["totalPrice"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "productId": productId.toJson(),
    "quantity": quantity,
    "totalPrice": totalPrice,
  };

  //Convert to item
  Item toItem() {
    return Item(
      id: productId.id,
      title: productId.title,
      itemTags: [],
      code: '',
      isAvailable: true,
      supplier: productId.supplier.id,
      description: '',
      price: productId.price?? 0.0,
      imageUrl: productId.imageUrl ?? [],
      v: 0,
      category: '',
    );
  }
}

class ProductId {
  final String id;
  final String title;
  final double? price;
  final Supplier supplier;
  final List<String>? imageUrl;

  ProductId({
    required this.id,
    required this.title,
    required this.price,
    required this.supplier,
    required this.imageUrl,
  });

  factory ProductId.fromJson(Map<String, dynamic> json) => ProductId(
        id: json["_id"],
        title: json["title"],
        price: json["price"]?.toDouble(),
        supplier: Supplier.fromJson(json["supplier"]),
        imageUrl: List<String>.from(json["imageUrl"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
      "_id": id,
      "title": title,
      "price": price,
      "supplier": supplier.toJson(),
      "imageUrl": imageUrl != null
          ? List<dynamic>.from(imageUrl!.map((x) => x))
          : null,
    };
}

class Supplier {
  final Coords coords;
  final String id;
  final String time;

  Supplier({
    required this.coords,
    required this.id,
    required this.time,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) => Supplier(
    coords: Coords.fromJson(json["coords"]),
    id: json["_id"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "coords": coords.toJson(),
    "_id": id,
    "time": time,
  };
}

class Coords {
  final String id;
  final double latitude;
  final double longitude;
  final String address;
  final String title;
  final double latitudeDelta;
  final double longitudeDelta;

  Coords({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.title,
    required this.latitudeDelta,
    required this.longitudeDelta,
  });

  factory Coords.fromJson(Map<String, dynamic> json) => Coords(
    id: json["id"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    address: json["address"],
    title: json["title"],
    latitudeDelta: json["latitudeDelta"]?.toDouble(),
    longitudeDelta: json["longitudeDelta"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "latitude": latitude,
    "longitude": longitude,
    "address": address,
    "title": title,
    "latitudeDelta": latitudeDelta,
    "longitudeDelta": longitudeDelta,
  };
}
