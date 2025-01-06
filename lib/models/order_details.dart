import 'dart:convert';

import 'package:intl/intl.dart';

GetOrder getOrderFromJson(String str) => GetOrder.fromJson(json.decode(str));

String getOrderToJson(GetOrder data) => json.encode(data.toJson());

class GetOrder {
  final String id;
  final UserId userId;
  final List<OrderItem> orderItems;
  final double orderTotal;
  final double deliveryFee;
  final DeliveryAddress deliveryAddress;
  final DateTime deliveryDate;
  final String orderStatus;
  final SupplierId supplierId;
  final List<double> supplierCoords;
  final List<double> recipientCoords;

  GetOrder({
    required this.id,
    required this.userId,
    required this.orderItems,
    required this.orderTotal,
    required this.deliveryFee,
    required this.deliveryAddress,
    required this.deliveryDate,
    required this.orderStatus,
    required this.supplierId,
    required this.supplierCoords,
    required this.recipientCoords,
  });

  factory GetOrder.fromJson(Map<String, dynamic> json) => GetOrder(
        id: json["_id"],
        userId: UserId.fromJson(json["userId"]),
        orderItems: List<OrderItem>.from(json["orderItems"].map((x) => OrderItem.fromJson(x))),
        orderTotal: json["orderTotal"]?.toDouble(),
        deliveryFee: json["deliveryFee"]?.toDouble(),
        deliveryAddress: DeliveryAddress.fromJson(json["deliveryAddress"]),
        deliveryDate: DateTime.parse(json["deliveryDate"]),
        orderStatus: json["orderStatus"],
        supplierId: SupplierId.fromJson(json["supplierId"]),
        supplierCoords: List<double>.from(json["supplierCoords"].map((x) => x?.toDouble())),
        recipientCoords: List<double>.from(json["recipientCoords"].map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId.toJson(),
        "orderItems": List<dynamic>.from(orderItems.map((x) => x.toJson())),
        "orderTotal": orderTotal,
        "deliveryFee": deliveryFee,
        "deliveryAddress": deliveryAddress.toJson(),
        "deliveryDate": DateFormat('yyyy-MM-dd').format(deliveryDate),
        "orderStatus": orderStatus,
        "supplierId": supplierId.toJson(),
        "supplierCoords": List<dynamic>.from(supplierCoords.map((x) => x)),
        "recipientCoords": List<dynamic>.from(recipientCoords.map((x) => x)),
      };
}

class DeliveryAddress {
  final String id;
  final String addressLine1;

  DeliveryAddress({
    required this.id,
    required this.addressLine1,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) =>
      DeliveryAddress(
        id: json["_id"],
        addressLine1: json["addressLine1"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "addressLine1": addressLine1,
      };
}

class OrderItem {
  final ItemId itemId;
  final int quantity;
  final double price;
  final String instructions;
  final String id;

  OrderItem({
    required this.itemId,
    required this.quantity,
    required this.price,
    required this.instructions,
    required this.id,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        itemId: ItemId.fromJson(json["itemId"]),
        quantity: json["quantity"],
        price: json["price"]?.toDouble(),
        instructions: json["instructions"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "itemId": itemId.toJson(),
        "quantity": quantity,
        "price": price,
        "instructions": instructions,
        "_id": id,
      };
}

class ItemId {
  final String id;
  final String title;
  final String? unit;
  final List<String> imageUrl;

  ItemId({
    required this.id,
    required this.title,
    required this.unit,
    required this.imageUrl,
  });

  factory ItemId.fromJson(Map<String, dynamic> json) => ItemId(
        id: json["_id"],
        title: json["title"],
        unit: json["unit"],
        imageUrl: List<String>.from(json["imageUrl"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "unit": unit,
        "imageUrl": List<dynamic>.from(imageUrl.map((x) => x)),
      };
}

class SupplierId {
  final Coords coords;
  final String id;
  final String title;
  final String time;
  final String imageUrl;
  final String logoUrl;

  SupplierId({
    required this.coords,
    required this.id,
    required this.title,
    required this.time,
    required this.imageUrl,
    required this.logoUrl,
  });

  factory SupplierId.fromJson(Map<String, dynamic> json) => SupplierId(
        coords: Coords.fromJson(json["coords"]),
        id: json["_id"],
        title: json["title"],
        time: json["time"],
        imageUrl: json["imageUrl"],
        logoUrl: json["logoUrl"],
      );

  Map<String, dynamic> toJson() => {
        "coords": coords.toJson(),
        "_id": id,
        "title": title,
        "time": time,
        "imageUrl": imageUrl,
        "logoUrl": logoUrl,
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

class UserId {
  final String id;
  final String phone;
  final String profile;

  UserId({
    required this.id,
    required this.phone,
    required this.profile,
  });

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        id: json["_id"],
        phone: json["phone"],
        profile: json["profile"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "phone": phone,
        "profile": profile,
      };
}
