import 'package:pixel_pos/data/database_helper.dart';

class DatabaseInvoiceService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // create invoice
  Future<int> createInvoice(String name, String status, double total) async {
    final db = await _dbHelper.database;
    return await db.insert('invoices', {
      'name': name,
      'status': status,
      'total': total,
    });
  }

  // get all invoices
  Future<List<Map<String, dynamic>>> getAllInvoices() async {
    final db = await _dbHelper.database;
    return await db.query('invoices');
  }

  // get by id
  Future<Map<String, dynamic>?> getInvoiceById(int id) async {
    final db = await _dbHelper.database;
    final result = await db.query('invoices', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // update invoice
  Future<int> updateInvoice(
    int id,
    String name,
    String status,
    double total,
  ) async {
    final db = await _dbHelper.database;
    return await db.update(
      'invoices',
      {'name': name, 'status': status, 'total': total},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // delete invoice
  Future<int> deleteInvoice(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('invoices', where: 'id = ?', whereArgs: [id]);
  }
}
