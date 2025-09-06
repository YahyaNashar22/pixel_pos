import 'package:pixel_pos/data/database_helper.dart';

class DatabaseCategoryService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // create category
  Future<int> createCategory(String name) async {
    final db = await _dbHelper.database;
    return await db.insert('categories', {'name': name});
  }

  // get all categories
  Future<List<Map<String, dynamic>>> getAllCategories() async {
    final db = await _dbHelper.database;
    return await db.query('categories', orderBy: 'name ASC');
  }

  // get by id
  Future<Map<String, dynamic>?> getCategoryById(int id) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // update category
  Future<int> updateCategory(int id, String name) async {
    final db = await _dbHelper.database;
    return await db.update(
      'categories',
      {'name': name},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // delete category
  Future<int> deleteCategory(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }
}
