import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping/model/CartModel.dart';
import 'package:shopping/model/ProductModel.dart';
import 'package:shopping/provider/CartProvider.dart';
import '../db/DatabaseService.dart';
import '../provider/HomeProvider.dart';

class CartScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.watch(databaseSqliteProvider);
    final total = ref.watch(totalCartProvider);
    final listCart = ref.watch(listCartProvider);
    final listProduct = ref.watch(listProductProvider);
    final checkCart = ref.watch(checkCartProvider);
    if(!checkCart){
      database.getCarts().then((list) {
        ref.read(listCartProvider.notifier).setCarts(list);
        ref.read(totalCartProvider.notifier).updateTotalCart(list);
        ref.read(checkCartProvider.notifier).state = true;
      });
    }
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 245),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 243, 243, 245),
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        //   icon: const Icon(
        //     Icons.arrow_back_ios,
        //     color: Colors.black,
        //   ),
        // ),
        title: const Text(
          'My Cart',
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
              itemCount: listCart!.length,
              itemBuilder: (BuildContext context, int index) {
                CartModel cart = listCart[index];
                ProductModel? product = ProductModel();
                for (ProductModel productModel in listProduct) {
                  if (cart.productId == productModel.id) {
                    product = productModel;
                    break;
                  }
                }
                return itemProduct(context, index, product, cart, ref);
              },
            )),
            Container(
              height: MediaQuery.of(context).size.height * 0.13,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Subtotal :',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        '\$${total}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    margin: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 246, 122, 80),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25))),
                      onPressed: () {
                        context.goNamed('Checkout', extra: total);
                      },
                      child: const Text(
                        'Checkout',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget itemProduct(BuildContext context, int index, ProductModel? product,
    CartModel? cartModel, WidgetRef ref) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(10)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 4,
          height: MediaQuery.of(context).size.width / 4,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 208, 208, 210),
              borderRadius: BorderRadius.circular(10)),
          child: Image.asset(product?.img ?? ''),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product?.name ?? '',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '\$${product?.price.toString()}' ?? '',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 3.5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.08,
                height: MediaQuery.of(context).size.width * 0.08,
                child: ElevatedButton(
                  onPressed: () {
                    if (cartModel != null) {
                      cartModel.quantity = cartModel.quantity! - 1;
                      ref.read(checkCartProvider.notifier).state = false;
                      ref.read(listCartProvider.notifier).updateCart(cartModel);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      backgroundColor:
                          const Color.fromARGB(255, 254, 232, 225)),
                  child: const Icon(Icons.remove,
                      color: Color.fromARGB(255, 246, 122, 80)),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.1,
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    cartModel?.quantity.toString() ?? "0",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.08,
                height: MediaQuery.of(context).size.width * 0.08,
                child: ElevatedButton(
                  onPressed: () {
                    if (cartModel != null) {
                      cartModel.quantity = cartModel.quantity! + 1;
                      ref.read(checkCartProvider.notifier).state = false;
                      ref.read(listCartProvider.notifier).updateCart(cartModel);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      backgroundColor:
                          const Color.fromARGB(255, 254, 232, 225)),
                  child: const Icon(Icons.add,
                      color: Color.fromARGB(255, 246, 122, 80)),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
