import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping/model/CartModel.dart';
import 'package:shopping/model/ProductModel.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  Database? db;
  String productBD = 'PRODUCT';
  String cartDB = 'CART';

  Future<Database?> get database async {
    if (db != null) return db;
    await initDB();
    return db;
  }

  initDB() async {
    try {
      String path = join(await getDatabasesPath(), 'my_database.db');
      db = await openDatabase(path, version: 1, onCreate: _onCreate);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool? checkInitDB = prefs.getBool('checkInitDB');
      if (checkInitDB == null) {
        await prefs.setBool('checkInitDB', true);
        await db?.transaction((txn) async {
          await txn.rawInsert(
              'INSERT INTO $productBD(name, price, img, type, category, description, color, size) VALUES("Long Sleeve Shirts", 165, "assets/images/product_0.png", "Shirt", "New Arrival", "A henley shirts is collarless pullover shirt, by a round neckline and placket ablout 3 to 5 inches(8 to 13 cm) long and usually having 2-5 buttons.", "Green", "M") ');
          await txn.rawInsert(
              'INSERT INTO $productBD(name, price, img, type, category, description, color, size) VALUES("Curred Hem Shirts", 195, "assets/images/product_1.png", "Tshirt", "Top Tranding", "A henley shirts is collarless pullover shirt, by a round neckline and placket ablout 3 to 5 inches(8 to 13 cm) long and usually having 2-5 buttons.", "Green", "M") ');
          await txn.rawInsert(
              'INSERT INTO $productBD(name, price, img, type, category, description, color, size) VALUES("Casual Henley Shirts", 139, "assets/images/product_2.png", "Tshirt", "New Arrival", "A henley shirts is collarless pullover shirt, by a round neckline and placket ablout 3 to 5 inches(8 to 13 cm) long and usually having 2-5 buttons.", "Green", "M") ');
          await txn.rawInsert(
              'INSERT INTO $productBD(name, price, img, type, category, description, color, size) VALUES("Casual Nolin", 159, "assets/images/product_3.png", "Shirt", "Top Tranding", "A henley shirts is collarless pullover shirt, by a round neckline and placket ablout 3 to 5 inches(8 to 13 cm) long and usually having 2-5 buttons.", "Green", "M" )');
          await txn.rawInsert(
              'INSERT INTO $productBD(name, price, img, type, category, description, color, size) VALUES("Pant", 159, "assets/images/product_4.png", "Pants", "Top Tranding", "A henley shirts is collarless pullover shirt, by a round neckline and placket ablout 3 to 5 inches(8 to 13 cm) long and usually having 2-5 buttons.", "Green", "M" )');
          await txn.rawInsert(
              'INSERT INTO $productBD(name, price, img, type, category, description, color, size) VALUES("Dress", 159, "assets/images/product_5.png", "Dress", "Top Tranding", "A henley shirts is collarless pullover shirt, by a round neckline and placket ablout 3 to 5 inches(8 to 13 cm) long and usually having 2-5 buttons.", "Green", "M" )');
        });
      }
    } catch (e) {
      print(e);
    }
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $productBD (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        price INTEGER,
        img TEXT,
        type TEXT,
        category TEXT,
        description TEXT,
        color TEXT,
        size TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE $cartDB (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER,
        quantity INTEGER
      )
    ''');
  }

  Future<ProductModel> insertProduct(ProductModel productModel) async {
    await db?.insert(productBD, productModel.toJson());
    return productModel;
  }

  Future<List<ProductModel>?> getProducts() async {
    await initDB();
    List<Map<String, dynamic>>? list = await db?.query(productBD);
    if (list != null) {
      return list.map((product) => ProductModel.fromJson(product)).toList();
    }
    return null;
  }

  Future<ProductModel?> getProductById(CartModel cartModel) async {
    await initDB();
    List<Map<String, dynamic>>? list = await db
        ?.query(productBD, where: 'id = ?', whereArgs: [cartModel.productId]);
    if (list != null) {
      return ProductModel.fromJson(list.elementAt(0));
    }
    return null;
  }

  Future<List<ProductModel>?> getProductByType(String type) async {
    await initDB();
    List<Map<String, dynamic>>? list =
        await db?.query(productBD, where: 'type = ?', whereArgs: [type]);
    if (list != null) {
      return list.map((product) => ProductModel.fromJson(product)).toList();
    }
    return null;
  }

  Future<List<ProductModel>?> getProductByCategory(String category) async {
    await initDB();
    List<Map<String, dynamic>>? list = await db
        ?.query(productBD, where: 'category = ?', whereArgs: [category]);
    if (list != null) {
      return list.map((product) => ProductModel.fromJson(product)).toList();
    }
    return null;
  }

  Future<List<ProductModel>?> getProductByName(String type, String name) async {
    await initDB();
    List<Map<String, dynamic>>? list = await db?.query(productBD,
        where: 'name LIKE ? AND type = ?', whereArgs: ['%$name%', type]);
    if (list != null) {
      return list.map((product) => ProductModel.fromJson(product)).toList();
    }
    return null;
  }

  Future<void> insertCart(CartModel cartModel) async {
    await initDB();
    await db?.insert(cartDB, cartModel.toJson());
  }

  Future<List<CartModel>?> getCarts() async {
    await initDB();
    List<Map<String, dynamic>>? list = await db?.query(cartDB);
    if (list != null) {
      return list.map((cart) => CartModel.fromJson(cart)).toList();
    }
    return null;
  }

  Future<void> updateCart(CartModel cartModel) async {
    await initDB();
    await db?.update(
      cartDB,
      cartModel.toJson(),
      where: 'id = ?',
      whereArgs: [cartModel.id],
    );
  }

  Future<void> deleteCartById(CartModel cartModel) async {
    await initDB();
    await db?.delete(cartDB, where: 'id = ?', whereArgs: [cartModel.id]);
  }

  Future<void> deleteCart() async {
    await initDB();
    await db?.delete(cartDB);
  }
}

final databaseSqliteProvider = Provider((ref) => DatabaseService());
