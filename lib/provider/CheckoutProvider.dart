import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shopping/db/DatabaseService.dart';
import 'package:shopping/db/FirebaseService.dart';

class CheckoutProvider{
  FirebaseService firebase = FirebaseService();
  DatabaseService db = DatabaseService();
  Future<void> handlePayment(BuildContext context, value, payment) async {
    try {
      String money = "${value}00";
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer sk_test_51OffYOA6GRrj7Svo2iP64CTIOdo4uPRldZ74a4q7epFJCMr2hYph2TpvW3oYVKFzQqzOXyYFzGLRJb9lQjzPZMZy00Hiald1R8',
        },
        body: {
          'amount': money.toString(),
          'currency': 'usd',
          'payment_method_types[]': 'card',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
        json.decode(response.body);
        final String clientSecret = data['client_secret'];
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters:
          SetupPaymentSheetParameters(
            paymentIntentClientSecret: clientSecret,
            merchantDisplayName: 'Merchant Name',
          ),
        );
        await Stripe.instance.presentPaymentSheet().then((value) {
            firebase.addPayment(payment);
            db.deleteCart();
            context.goNamed('Home');
        });
      } else {
        print('Failed to create payment: ${response.statusCode}');
      }
    } catch (error) {
      print('Error creating payment: $error');
    }
  }
}
final checkoutProvider = Provider((ref) => CheckoutProvider());
final payMethodProvider = StateProvider<String>((ref) => 'apple-pay');
final locationProvider = StateProvider<String>((ref) => 'Home');