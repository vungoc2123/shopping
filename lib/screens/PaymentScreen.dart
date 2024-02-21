
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shopping/db/FirebaseService.dart';
import 'package:shopping/model/CartModel.dart';
import 'package:shopping/model/PaymentModel.dart';
import 'package:shopping/model/ProductModel.dart';
import 'package:shopping/provider/HomeProvider.dart';

class PaymentScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebase = ref.watch(firebaseProvider);
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
            'My Bill',
            style: TextStyle(
                color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: StreamBuilder<List<PaymentModel>>(
              stream: firebase.getPayments(),
              builder: (BuildContext context, snapshot) {
                return snapshot.hasData ? ListView.builder(
                  itemCount: snapshot.data?.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    PaymentModel? paymentModel = snapshot.data?[index];
                    return itemBill(ref, paymentModel);
                  },
                ) : const SizedBox.shrink();
              }
          ),
        ));
  }
}

Widget itemBill(WidgetRef ref,PaymentModel? payment) {
  return Container(
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: Colors.grey, // Set the color of the border
        width: 1, // Set the width of the border
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Expanded(
                child: Text(
                  "Ngày",
                  style: TextStyle(fontSize: 18),
                )),
            Text(
              DateFormat('dd-MM-yyyy').format(DateTime.parse(payment?.date ?? '')),
              style: const TextStyle(fontSize: 18),
            )
          ],
        ),
        const Divider(
          color: Colors.grey, // Màu sắc của đường
          thickness: 1, // Độ dày của đường
        ),
        ListView.builder(
          itemCount: payment?.listCart?.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            CartModel? cart = payment?.listCart?[index];
            return itemDetail(ref, cart);
          },
        ),
        const Divider(
          color: Colors.grey, // Màu sắc của đường
          thickness: 1, // Độ dày của đường
        ),
        Row(
          children: [
            const Expanded(
                child: Text(
                  "Tổng tiền",
                  style: TextStyle(fontSize: 18),
                )),
            Text('${payment?.money}',
              style: const TextStyle(fontSize: 18),
            )
          ],
        ),
      ],
    ),
  );
}

Widget itemDetail(WidgetRef ref, CartModel? cartModel) {
  final products = ref.watch(listProductProvider);
  ProductModel productModel = ProductModel();
  for (ProductModel product in products) {
    if (cartModel?.productId == product.id) {
      productModel = product;
      break;
    }
  }
  return Row(
    children: [
      Expanded(
          child: Text(
            productModel.name ?? '',
            style: const TextStyle(
              fontSize: 18,
            ),
          )),
      Text('x${cartModel?.quantity}',
        style: const TextStyle(fontSize: 18),
      )
    ],
  );
}
