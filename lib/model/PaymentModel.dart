import 'CartModel.dart';

class PaymentModel {
  String? id;
  List<CartModel>? listCart;
  int? money;
  String? date;

  PaymentModel({this.id, this.listCart, this.money, this.date});

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    List<dynamic>? list = json['listCart'];
    List<CartModel> carts = list != null
        ? list.map((item) => CartModel.fromJson(item)).toList()
        : [];
    return PaymentModel(
        id: json['id'],
        listCart: carts,
        money: json['money'],
        date: json['date']);
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> cartListJson = listCart != null
        ? listCart!.map((cart) => cart.toJson()).toList()
        : [];

    return {
      "id": id,
      "listCart": cartListJson,
      "money": money,
      "date": date,
    };
  }
}
