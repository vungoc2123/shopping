import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/ProductModel.dart';

final typeProvider = StateProvider<String>((ref) => 'Shirt');
final categoryFilterProvider = StateProvider<String>((ref) => 'New Arrival');
final priceFilterProvider = StateProvider<double>((ref) => 50);
final listProductProvider = StateProvider<List<ProductModel>>((ref) => []);
final listProductProviderByType = StateProvider<List<ProductModel>>((ref) => []);
final checkProvider = StateProvider<bool>((ref) => false);