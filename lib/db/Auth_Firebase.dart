
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping/model/UserModel.dart';
class Auth_Firebase{
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<bool> signInWithEmailAndPassword(BuildContext context, UserModel userModel) async {
    var login = false;
    try {
      await auth.signInWithEmailAndPassword(
        email: userModel.email!,
        password: userModel.password!,
      );
      context.go('/Home');
    } catch (e) {
      login = true;
      print("Đăng nhập thất bại: $e");
    }
    return login;
  }

  Future<bool> registerWithEmailAndPassword(BuildContext context, UserModel userModel) async {
    var signup = false;
    try {
      await auth.createUserWithEmailAndPassword(
        email: userModel.email!,
        password: userModel.password!,
      );
      User? user = FirebaseAuth.instance.currentUser;
      await firestore.collection('users').doc(user?.uid).set({
        'name': userModel.name!,
        'email': userModel.email!,
        'password': userModel.password!,
      });
      context.go('/');
      print("Đăng ký thành công!");
    } catch (e) {
      signup = true;
      print("Đăng ký thất bại: $e");
    }
    return signup;
  }
}