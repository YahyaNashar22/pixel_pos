import 'package:pixel_pos/data/database_helper.dart';

class DatabaseCompanyService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // check if company exists
  Future<bool> checkIfCompanyExists() async {
    final db = await _dbHelper.database;
    final result = await db.query('company', limit: 1);
    return result.isNotEmpty;
  }

  // Insert company
  Future<int> registerCompany(String name, String logo) async {
    final db = await _dbHelper.database;
    return await db.insert('company', {'name': name, 'logo': logo});
  }
}
