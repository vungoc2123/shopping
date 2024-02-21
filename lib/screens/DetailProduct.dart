import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping/db/FirebaseService.dart';
import 'package:shopping/model/CartModel.dart';
import 'package:shopping/model/ProductModel.dart';
import 'package:shopping/provider/CartProvider.dart';


final sizeProvider = StateProvider<String>((ref) => 'M');
final colorProvider = StateProvider<String>((ref) => 'Green');

class DetailProduct extends ConsumerWidget {
  ProductModel? product;
  DetailProduct({super.key, this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final firebase = ref.watch(firebaseProvider);
    final size = ref.watch(sizeProvider);
    final colorPd = ref.watch(colorProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 239, 238, 243),
        leading: IconButton(
            onPressed: () {
              GoRouter.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.redAccent),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 239, 238, 243),
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              child: Image.asset(product?.img ?? ''),
            ),
            Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.3,
                            child: Text(
                              product?.name ?? '',
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            width: MediaQuery.of(context).size.width / 2.3,
                            child: Text(
                              '\$${product?.price.toString()}' ?? '',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      Text(
                        product?.description ?? '',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                      const Text(
                        'Colors',
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          itemColor(context, 'Green', Colors.greenAccent, ref),
                          itemColor(context, 'Black', Colors.black, ref),
                          itemColor(context, 'Blue', Colors.blueAccent, ref),
                          itemColor(
                              context, 'Yellow', Colors.yellowAccent, ref),
                        ],
                      ),
                      const Text(
                        'Size',
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            itemSize(context, 'M', ref),
                            itemSize(context, 'L', ref),
                            itemSize(context, 'XL', ref),
                            itemSize(context, 'XXL', ref),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 246, 122, 80),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25))),
                          onPressed: () {
                            product?.color = colorPd;
                            product?.size = size;
                            CartModel cart = CartModel(productId: product?.id ,quantity: 1);
                            ref.read(checkCartProvider.notifier).state = false;
                            ref.read(listCartProvider.notifier).addCart(cart);
                          },
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

Widget itemColor(
    BuildContext context, String label, Color color, WidgetRef ref) {
  final colorPd = ref.watch(colorProvider);
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
            width: 2,
            color: colorPd == label ? Colors.redAccent : Colors.transparent)),
    child: InkWell(
        onTap: () {
          ref.read(colorProvider.notifier).state = label;
        },
        child: Icon(Icons.circle, color: color)),
  );
}

Widget itemSize(BuildContext context, String label, WidgetRef ref) {
  final size = ref.watch(sizeProvider);
  return Container(
    width: MediaQuery.of(context).size.width / 5,
    child: ElevatedButton(
        onPressed: () {
          ref.read(sizeProvider.notifier).state = label;
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: size == label
              ? const Color.fromARGB(255, 246, 122, 80)
              : Colors.white,
        ),
        child: Text(
          label,
          style: TextStyle(
              color: size == label ? Colors.white : Colors.black, fontSize: 16),
        )),
  );
}
