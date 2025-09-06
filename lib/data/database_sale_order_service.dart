import 'package:pixel_pos/data/database_helper.dart';

class DatabaseSaleOrderService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // create saleOrder
  Future<int> createSaleOrder(int productId, int invoiceId) async {
    final db = await _dbHelper.database;
    return await db.insert('sale_orders', {
      'product_id': productId,
      'invoiceId': invoiceId,
    });
  }

  // get all saleOrders
  Future<List<Map<String, dynamic>>> getAllSaleOrders() async {
    final db = await _dbHelper.database;
    return await db.query('sale_orders');
  }

  // get by id
  Future<Map<String, dynamic>?> getSaleOrderById(int id) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'sale_orders',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // update saleOrder
  Future<int> updateSaleOrder(int id, int productId, int invoiceId) async {
    final db = await _dbHelper.database;
    return await db.update(
      'sale_orders',
      {'product_id': productId, 'invoice_id': invoiceId},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // delete saleOrder
  Future<int> deleteSaleOrder(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('sale_orders', where: 'id = ?', whereArgs: [id]);
  }
}
