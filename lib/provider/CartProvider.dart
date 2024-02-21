import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/DatabaseService.dart';
import '../model/CartModel.dart';
import '../model/ProductModel.dart';

class CartListNotifier extends StateNotifier<List<CartModel>> {
  CartListNotifier() : super([]);
  DatabaseService db = DatabaseService();

  Future<void> addCart(CartModel cartModel) async {
    await db.insertCart(cartModel);
    await db.getCarts().then((value) => {state = value!});
  }

  Future<void> setCarts(List<CartModel>? list) async {
    state = list ?? [];
  }

  Future<void> updateCart(CartModel cartModel) async {
    if(cartModel.quantity == 0){
      await db.deleteCartById(cartModel);
    }else{
      await db.updateCart(cartModel);
    }
    await db.getCarts().then((value) => {state = value!});
  }
}

class TotalCartNotifier extends StateNotifier<int>{
  TotalCartNotifier() : super(0);
  DatabaseService db = DatabaseService();
  Future<void> updateTotalCart(List<CartModel>? list,) async {
    int total = 0;
    for(CartModel cart in list ?? []){
      ProductModel product = await db.getProductById(cart) as ProductModel;
      int price = cart.quantity! * product.price!;
      total += price;
    }
    state = total;
  }
}

final totalCartProvider = StateNotifierProvider<TotalCartNotifier, int>(
      (ref) => TotalCartNotifier(),
);

final listCartProvider =
StateNotifierProvider<CartListNotifier, List<CartModel>>(
      (ref) => CartListNotifier(),
);

final checkCartProvider = StateProvider<bool>((ref) => false);



