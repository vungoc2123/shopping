import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping/screens/HomeScreen.dart';
import 'package:shopping/screens/PaymentScreen.dart';
import 'CartScreen.dart';

final indexProvider = StateProvider<int>((ref) => 0);

class HomePage extends ConsumerWidget {
  static List<Widget> listWidget = <Widget>[
    HomeScreen(),
    CartScreen(),
    PaymentScreen()
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(indexProvider);
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height -
                  kBottomNavigationBarHeight,
              child: listWidget[index]),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Color(0xFFF77951),
            // Đặt màu cho các item được chọn
            unselectedItemColor: Colors.grey,
            // Đặt màu cho các item không được chọn
            items: [
              BottomNavigationBarItem(
                icon: Icon(index == 0 ? Icons.home : Icons.home_outlined),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(index == 1
                    ? Icons.shopping_cart
                    : Icons.shopping_cart_outlined),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(index == 2
                    ? Icons.favorite
                    : Icons.favorite_border_outlined),
                label: '',
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(index == 3 ? Icons.person : Icons.person_outlined),
              //   label: '',
              // ),
            ],
            currentIndex: index,
            onTap: (value) {
              ref.read(indexProvider.notifier).state = value;
            },
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
