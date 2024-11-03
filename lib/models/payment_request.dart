import 'dart:convert';

Payment paymentFromJson(String str) => Payment.fromJson(json.decode(str));

String paymentToJson(Payment data) => json.encode(data.toJson());

class Payment {
  final String userId;
  final List<CartItemPayment> cartItems;

  Payment({
    required this.userId,
    required this.cartItems,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        userId: json["userId"],
        cartItems: List<CartItemPayment>.from(
            json["cartItems"].map((x) => CartItemPayment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "cartItems": List<dynamic>.from(cartItems.map((x) => x.toJson())),
      };
}

class CartItemPayment {
  final String name;
  final String id;
  final String price;
  final int quantity;
  final String supplierId;

  CartItemPayment({
    required this.name,
    required this.id,
    required this.price,
    required this.quantity,
    required this.supplierId,
  });

  factory CartItemPayment.fromJson(Map<String, dynamic> json) =>
      CartItemPayment(
        name: json["name"],
        id: json["id"],
        price: json["price"],
        quantity: json["quantity"],
        supplierId: json["supplierId"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "price": price,
        "quantity": quantity,
        "supplierId": supplierId,
      };
}
