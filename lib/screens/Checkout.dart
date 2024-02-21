
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shopping/model/PaymentModel.dart';
import 'package:shopping/model/UserModel.dart';
import 'package:shopping/provider/CheckoutProvider.dart';

import '../model/CartModel.dart';
import '../provider/CartProvider.dart';


class Checkout extends ConsumerWidget {
  int? total;
  Checkout({super.key, this.total});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkout = ref.watch(checkoutProvider);
    final listCart = ref.watch(listCartProvider);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 245),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 243, 243, 245),
        leading: IconButton(
            onPressed: () {
              GoRouter.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black)),
        title: const Text(
          'Checkout',
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: const Text(
                  'Delivery address',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              itemAddress(
                  "Home",
                  UserModel(
                      phone: '0384745334', location: '220 Nguyen Chi Thanh'),
                  ref),
              itemAddress(
                  "Office",
                  UserModel(
                      phone: '0384745334', location: '195 Phung Chi Kien'),
                  ref),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: const Text(
                  'Billing information',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              billInfo(total ?? 0),
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 10),
                child: const Text(
                  'Payment Method',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  itemPayment(
                      context, 'assets/icons/apple-pay.png', 'apple-pay', ref),
                  itemPayment(context, 'assets/icons/visa.png', 'visa', ref),
                  itemPayment(
                      context, 'assets/icons/symbols.png', 'symbols', ref),
                  itemPayment(
                      context, 'assets/icons/google-pay.png', 'google-pay', ref)
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(vertical: 40),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 246, 122, 80),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                  onPressed: () async {
                    int money = total! + 20;
                    DateTime date = DateTime.now();
                    String formattedDate = DateFormat('dd-MM-yyyy').format(date);
                    PaymentModel payment = PaymentModel(listCart: listCart, money: money, date: date.toIso8601String());
                    await checkout.handlePayment(context,money, payment);
                    ref.read(checkCartProvider.notifier).state = false;
                  },
                  child: const Text(
                    'Swipe for Payment',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget itemAddress(String label, UserModel userModel, WidgetRef ref) {
  final location = ref.watch(locationProvider);
  return InkWell(
    onTap: () {
      ref.read(locationProvider.notifier).state = label;
    },
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: location == label
              ? Colors.white
              : const Color.fromARGB(255, 243, 243, 245),
          border: Border.all(
            color: Colors.grey, // Set the color of the border
            width: 1, // Set the width of the border
          )),
      child: Row(
        children: [
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                location == label ? Icons.check_circle : Icons.circle_outlined,
                size: 30,
                color: location == label
                    ? const Color.fromARGB(255, 246, 122, 80)
                    : Colors.grey,
              )),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    userModel.phone ?? '',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                Text(
                  userModel.location ?? '',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                )
              ],
            ),
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.edit_location_sharp,
                color: Colors.grey,
              ))
        ],
      ),
    ),
  );
}

Widget billInfo(int total) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(10)),
    child: Column(
      children: [
        Row(
          children: [
            const Text('Subtotal :',
                style: TextStyle(fontSize: 18, color: Colors.grey)),
            const Spacer(),
            Text('\$$total',
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: const [
                Text('VAT :',
                    style: TextStyle(fontSize: 18, color: Colors.grey)),
                Spacer(),
                Text('\$20',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ],
            )),
        const Divider(
          color: Colors.grey, // Màu của đường gạch
          thickness: 1, // Độ dày của đường gạch
        ),
        Row(
          children: [
            const Text('Total :',
                style: TextStyle(fontSize: 18, color: Colors.grey)),
            const Spacer(),
            Text('\$${total! + 20}',
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    ),
  );
}

Widget itemPayment(
    BuildContext context, String img, String label, WidgetRef ref) {
  final payMethod = ref.watch(payMethodProvider);
  return Container(
      width: MediaQuery.of(context).size.width / 5,
      color: const Color.fromARGB(255, 243, 243, 245),
      height: 56,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 5,
              child: ElevatedButton(
                  onPressed: () {
                    ref.read(payMethodProvider.notifier).state = label;
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, elevation: 0),
                  child: Image.asset(
                    img,
                    fit: BoxFit.contain,
                  )),
            ),
          ),
          if (payMethod == label)
            const Positioned(
                right: 0,
                top: 0,
                child: Icon(
                  Icons.check_circle,
                  size: 20,
                  color: Color.fromARGB(255, 93, 203, 154),
                )),
        ],
      ));
}

