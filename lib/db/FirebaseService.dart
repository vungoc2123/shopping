import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping/model/PaymentModel.dart';

class FirebaseService {
  static User? user = FirebaseAuth.instance.currentUser;

  Future<void> addPayment(PaymentModel paymentModel) async {
    try {
      paymentModel.id = user?.uid ?? '';
      FirebaseFirestore.instance
          .collection("payment")
          .add(paymentModel.toJson());
    } catch (error) {
      print("Error adding product to cart: $error");
    }
  }

  Stream<List<PaymentModel>> getPayments() {
    try {
      return FirebaseFirestore.instance
          .collection("payment")
          .where("id", isEqualTo: user?.uid)
          .orderBy("date", descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => PaymentModel.fromJson(doc.data()))
              .toList());
    } catch (e) {
      throw Exception('$e');
    }
  }

// Future<void> updateCart(int index, OrderProduct ordProduct) async {
//   try {
//     DocumentSnapshot snapshot =
//         await FirebaseFirestore.instance.collection("Cart").doc(user?.uid).get();
//     if (snapshot.exists) {
//       Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
//       List<dynamic> list = data["orderProducts"];
//       if(ordProduct.quantity == 0){
//         list.removeAt(index);
//       }else{
//         list[index] = ordProduct.toJson();
//       }
//       data["orderProducts"] = list;
//       FirebaseFirestore.instance
//           .collection("Cart")
//           .doc(user?.uid)
//           .update(data);
//     }
//   } catch (e) {
//     print(e);
//   }
// }
}

final firebaseProvider = Provider((ref) => FirebaseService());
