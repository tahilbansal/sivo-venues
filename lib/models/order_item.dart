import 'dart:convert';
import 'package:intl/intl.dart';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  final String userId;
  final List<OrderItem> orderItems;
  final String orderTotal;
  final String supplierAddress;
  final List<double> supplierCoords;
  final List<double> recipientCoords;
  final String deliveryFee;
  final String grandTotal;
  final String deliveryAddress;
  final DateTime deliveryDate;
  final String paymentMethod;
  final String supplierId;

  Order({
    required this.userId,
    required this.orderItems,
    required this.orderTotal,
    required this.supplierAddress,
    required this.supplierCoords,
    required this.recipientCoords,
    required this.deliveryFee,
    required this.grandTotal,
    required this.deliveryAddress,
    required this.deliveryDate,
    required this.paymentMethod,
    required this.supplierId,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        userId: json["userId"],
        orderItems: List<OrderItem>.from(json["orderItems"].map((x) => OrderItem.fromJson(x))),
        orderTotal: json["orderTotal"],
        supplierAddress: json["supplierAddress"],
        supplierCoords: List<double>.from(json["supplierCoords"].map((x) => x?.toDouble())),
        recipientCoords: List<double>.from(json["recipientCoords"].map((x) => x?.toDouble())),
        deliveryFee: json["deliveryFee"],
        grandTotal: json["grandTotal"],
        deliveryAddress: json["deliveryAddress"],
        deliveryDate: DateTime.parse(json["deliveryDate"]),
        paymentMethod: json["paymentMethod"],
        supplierId: json["supplierId"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "orderItems": List<dynamic>.from(orderItems.map((x) => x.toJson())),
        "orderTotal": orderTotal,
        "supplierAddress": supplierAddress,
        "supplierCoords": List<dynamic>.from(supplierCoords.map((x) => x)),
        "recipientCoords": List<dynamic>.from(recipientCoords.map((x) => x)),
        "deliveryFee": deliveryFee,
        "grandTotal": grandTotal,
        "deliveryAddress": deliveryAddress,
        "deliveryDate": DateFormat('yyyy-MM-dd').format(deliveryDate),
        "paymentMethod": paymentMethod,
        "supplierId": supplierId,
      };
}

class OrderItem {
  final String itemId;
  final List<String> additives;
  final String quantity;
  final String price;
  final String instructions;

  OrderItem({
    required this.itemId,
    required this.additives,
    required this.quantity,
    required this.price,
    required this.instructions,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        itemId: json["itemId"],
        additives: List<String>.from(json["additives"].map((x) => x)),
        quantity: json["quantity"],
        price: json["price"],
        instructions: json["instructions"],
      );

  Map<String, dynamic> toJson() => {
        "itemId": itemId,
        "additives": List<dynamic>.from(additives.map((x) => x)),
        "quantity": quantity,
        "price": price,
        "instructions": instructions,
      };
}

class ItemId {
  final String id;
  final String title;
  final List<String> imageUrl;
  //final String time;

  ItemId({
    required this.id,
    required this.title,
    required this.imageUrl,
    //required this.time,
  });

  factory ItemId.fromJson(Map<String, dynamic> json) => ItemId(
        id: json["_id"],
        title: json["title"],
        imageUrl: List<String>.from(json["imageUrl"].map((x) => x)),
        //time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "imageUrl": List<dynamic>.from(imageUrl.map((x) => x)),
        //"time": time,
      };
}
