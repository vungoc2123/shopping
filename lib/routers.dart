import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping/model/ProductModel.dart';
import 'package:shopping/screens/Checkout.dart';
import 'package:shopping/screens/DetailProduct.dart';
import 'package:shopping/screens/Home.dart';
import 'package:shopping/screens/auth/SignIn.dart';
import 'package:shopping/screens/auth/SignUp.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return SignInPage();
        }),
    GoRoute(
      path: '/SignUp',
      builder: (BuildContext context, GoRouterState state) {
        return SignUpPage();
      },
    ),
    GoRoute(
        name: 'Home',
        path: '/Home',
        builder: (BuildContext context, GoRouterState state) {
          return HomePage();
        },
        routes: [
          GoRoute(
            name: 'DetailProduct',
            path: 'DetailProduct',
            builder: (BuildContext context, GoRouterState state) {
              ProductModel product = state.extra as ProductModel;
              return DetailProduct(product: product);
            },
          ),
          GoRoute(
            path: 'Checkout',
            name: 'Checkout',
            builder: (BuildContext context, GoRouterState state) {
              int total = state.extra as int;
              return Checkout(total: total);
            },
          ),
        ]),
  ],
);
