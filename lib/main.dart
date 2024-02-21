import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shopping/routers.dart';
import 'db/DatabaseService.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "pk_test_51OffYOA6GRrj7SvotJQhSgF0zEFiumuQipPSu8mOsLcl3s5GXcixQssGWqwII71GEFmn00yO2hzUl3KKHiuoWGQN00FA4knCmD";
  await Stripe.instance.applySettings();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  DatabaseService bd = DatabaseService();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bd.database;
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
