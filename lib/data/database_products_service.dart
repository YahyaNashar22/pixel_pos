import 'package:pixel_pos/data/database_helper.dart';

class DatabaseProductService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // create product
  Future<int> createProduct(String name, double price, int categoryId) async {
    final db = await _dbHelper.database;
    return await db.insert('products', {
      'name': name,
      'price': price,
      'category_id': categoryId,
    });
  }

  // get all products
  Future<List<Map<String, dynamic>>> getAllProducts() async {
    final db = await _dbHelper.database;
    return await db.query('products', orderBy: 'name ASC');
  }

  // get by id
  Future<Map<String, dynamic>?> getProductById(int id) async {
    final db = await _dbHelper.database;
    final result = await db.query('products', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // update product
  Future<int> updateProduct(
    int id,
    String name,
    double price,
    int categoryId,
  ) async {
    final db = await _dbHelper.database;
    return await db.update(
      'products',
      {'name': name, 'price': price, 'category_id': categoryId},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // delete product
  Future<int> deleteProduct(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  // get all products with category name
  Future<List<Map<String, dynamic>>> getAllProductsWithCategory() async {
    final db = await _dbHelper.database;
    return await db.rawQuery('''
    SELECT p.id, p.name, p.price, p.category_id, c.name as category_name
    FROM products p
    JOIN categories c ON p.category_id = c.id
    ORDER BY p.name ASC
  ''');
  }
}
