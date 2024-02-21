
class CartModel {
  int? id;
  int? productId;
  int? quantity;

  CartModel({this.id, this.productId, this.quantity});

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
    id: json['id'],
    productId: json['productId'],
    quantity: json['quantity'],
  );

  Map<String, dynamic> toJson() => {
    "productId" : productId,
    "quantity" : quantity,
  };
}
