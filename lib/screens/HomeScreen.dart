import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping/db/DatabaseService.dart';
import 'package:shopping/model/ProductModel.dart';
import 'package:shopping/screens/DetailProduct.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../provider/HomeProvider.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 243, 245),
        body: SingleChildScrollView(
          child: Container(
            color: const Color.fromARGB(255, 243, 243, 245),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          'assets/icons/menu.svg', // Đường dẫn đến file SVG
                          width: 18,
                          height: 18,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            SvgPicture.asset(
                              'assets/icons/Location.svg',
                              // Đường dẫn đến file SVG
                              width: 18,
                              height: 18,
                            ),
                            const Text("15/2 New Texas"),
                          ]),
                        ),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.notifications))
                    ],
                  ),
                  body(context, ref)
                ],
              ),
            ),
          ),
        ));
  }
}

Widget body(BuildContext context, WidgetRef ref) {
  final database = ref.watch(databaseSqliteProvider);
  final list = ref.watch(listProductProviderByType);
  final type = ref.watch(typeProvider);
  final check = ref.watch(checkProvider);
  if (!check) {
    database.getProducts().then((value) => {
          ref.read(listProductProvider.notifier).state = value ?? [],
        });
    database.getProductByType(type).then((value) => {
          ref.read(listProductProviderByType.notifier).state = value ?? [],
          ref.read(checkProvider.notifier).state = true
        });
  }
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Explore",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "best Outfits for you",
          style: TextStyle(fontSize: 25, color: Color(0xFF9D9B9B)),
        ),
        const SizedBox(
          height: 20,
        ),
        search(context, ref),
        const SizedBox(
          height: 20,
        ),
        category(context, ref),
        const SizedBox(
          height: 20,
        ),
        GridView.builder(
          itemCount: list != null ? list.length : 0,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            ProductModel product = list[index];
            return itemProduct(context, product, ref);
          },
        ),
      ],
    ),
  );
}

Widget search(BuildContext context, WidgetRef ref) {
  final database = ref.watch(databaseSqliteProvider);
  final type = ref.watch(typeProvider);
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(10)),
    child: Row(
      children: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        Expanded(
          child: TextField(
            style: const TextStyle(fontSize: 18),
            decoration: const InputDecoration(
              hintText: 'Search items...',
              border: InputBorder.none,
            ),
            onChanged: (name) => {
              database.getProductByName(type, name).then((value) =>
                  ref.read(listProductProvider.notifier).state = value ?? [])
            },
          ),
        ),
        Container(
          width: 50,
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: ElevatedButton(
            onPressed: () {
              _showBottomSheet(context);
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              elevation: 0,
              backgroundColor: const Color.fromARGB(255, 246, 122, 80),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    10.0), // Set your desired border radius
              ),
            ),
            child: SvgPicture.asset(
                'assets/icons/Filter.svg', // Đường dẫn đến file SVG
                fit: BoxFit.none),
          ),
        )
      ],
    ),
  );
}

Widget category(BuildContext context, WidgetRef ref) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        itemCategory(context, 'assets/icons/shirt.svg', 'Shirt', ref),
        itemCategory(context, 'assets/icons/pants.svg', 'Pants', ref),
        itemCategory(context, 'assets/icons/dress.svg', 'Dress', ref),
        itemCategory(context, 'assets/icons/Tshirt.svg', 'Tshirt', ref),
      ],
    ),
  );
}

Widget itemCategory(
    BuildContext context, String img, String label, WidgetRef ref) {
  final select = ref.watch(typeProvider); // Access the provider using read
  return Container(
    width: MediaQuery.of(context).size.width / 5,
    height: 90,
    margin: EdgeInsets.only(right: label == 'Tshirt' ? 0 : 14),
    child: ElevatedButton(
      onPressed: () {
        ref.read(typeProvider.notifier).state = label;
        ref.read(checkProvider.notifier).state = false;
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Colors.grey, // Set your desired border color
            width: 1.0, // Set your desired border width
          ),
          borderRadius:
              BorderRadius.circular(10.0), // Set your desired border radius
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            img, // Đường dẫn đến file SVG
            width: 50,
            height: 50,
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
                color: select == label ? Colors.black : Colors.black54,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    ),
  );
}

Widget itemProduct(BuildContext context, ProductModel product, WidgetRef ref) {
  return SingleChildScrollView(
    child: InkWell(
      onTap: () {
        context.goNamed("DetailProduct", extra: product);
        ref.read(sizeProvider.notifier).state = product?.size ?? 'M';
        ref.read(colorProvider.notifier).state = product?.color ?? 'Green';
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white,
              width: 5,
            )),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2.4,
              height: MediaQuery.of(context).size.height / 6,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 254, 234, 231),
                  borderRadius: BorderRadius.circular(10)),
              child: Stack(
                children: [
                  Image.asset( product.img ?? '',
                      width: MediaQuery.of(context).size.width / 2),
                  Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        onPressed: () {},
                        icon: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25)),
                            child: const Icon(Icons.favorite)),
                        color: Colors.redAccent,
                      ))
                ],
              ),
            ),
            Container(
                margin: const EdgeInsets.all(5),
                child: Text(
                  product.name ?? '',
                  style: const TextStyle(fontSize: 16),
                )),
            Container(
                margin: const EdgeInsets.only(bottom: 5),
                child: const Text(
                  '\$100',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ),
    ),
  );
}

_showBottomSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final price = ref.watch(priceFilterProvider);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 243, 243, 245),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25), topLeft: Radius.circular(25))),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () {},
                          child: const Text(
                            'Clear',
                            style: TextStyle(fontSize: 16),
                          )),
                      const Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.clear))
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.grey, // Màu sắc của đường
                  thickness: 1, // Độ dày của đường
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: const Text(
                    'Category',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      itemCategoryFilter('New Arrival', ref),
                      const SizedBox(
                        width: 10,
                      ),
                      itemCategoryFilter('Top Tranding', ref),
                      const SizedBox(
                        width: 10,
                      ),
                      itemCategoryFilter('Featured Products', ref),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Pricing',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '\$50-\$200',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
                SfSlider(
                  min: 50,
                  max: 200,
                  value: price,
                  enableTooltip: true,
                  showLabels: true,
                  inactiveColor: const Color.fromARGB(255, 197, 195, 195),
                  activeColor: const Color.fromARGB(255, 246, 122, 80),
                  onChanged: (value) {
                    ref.read(priceFilterProvider.notifier).state = value;
                  },
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 246, 122, 80),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            25.0), // Set your desired border radius
                      ),
                    ),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )
              ]),
        );
      });
    },
  );
}

Widget itemCategoryFilter(String label, WidgetRef ref) {
  final category = ref.watch(categoryFilterProvider);
  return ElevatedButton(
      onPressed: () {
        ref.read(categoryFilterProvider.notifier).state = label;
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        backgroundColor: category == label
            ? const Color.fromARGB(255, 246, 122, 80)
            : Colors.white,
      ),
      child: Text(
        label,
        style: TextStyle(
            color: category == label ? Colors.white : Colors.black,
            fontSize: 16),
      ));
}
