import 'dart:convert';

ToCart toCartFromJson(String str) => ToCart.fromJson(json.decode(str));

String toCartToJson(ToCart data) => json.encode(data.toJson());

class ToCart {
  final String productId;
  final String instructions;
  final String supplierId;
  final List<String> additives;
  final int quantity;
  final double totalPrice;

  ToCart({
    required this.productId,
    required this.supplierId,
    required this.instructions,
    required this.additives,
    required this.quantity,
    required this.totalPrice,
  });

  factory ToCart.fromJson(Map<String, dynamic> json) => ToCart(
        productId: json["productId"],
        supplierId: json["supplierId"],
        instructions: json["instructions"],
        additives: List<String>.from(json["additives"].map((x) => x)),
        quantity: json["quantity"],
        totalPrice: json["totalPrice"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "supplierId": supplierId,
        "instructions": instructions,
        "additives": List<dynamic>.from(additives.map((x) => x)),
        "quantity": quantity,
        "totalPrice": totalPrice,
      };
}
