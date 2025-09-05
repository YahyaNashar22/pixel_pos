import 'package:pixel_pos/data/database_helper.dart';
import 'package:pixel_pos/models/company_model.dart';
import 'package:pixel_pos/models/user_model.dart';
import 'package:pixel_pos/services/session_manager.dart';

class DatabaseUsersService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // check if any users exist
  Future<bool> hasUser() async {
    final db = await _dbHelper.database;
    final result = await db.query('users', limit: 1);
    return result.isNotEmpty;
  }

  // register user
  Future<int> registerUser(
    String username,
    String password,
    String role,
  ) async {
    final db = await _dbHelper.database;
    return db.insert('users', {
      'username': username,
      'password': password,
      'role': role,
    });
  }

  // validate login
  Future<bool> loginUser(String username, String password) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (result.isNotEmpty) {
      // create user object
      final user = UserModel.fromMap(result.first);

      // fetch company
      final companyResult = await db.query('company', limit: 1);
      CompanyModel? company;
      if (companyResult.isNotEmpty) {
        company = CompanyModel.fromMap(companyResult.first);
      }

      // save results to session
      final session = SessionManager();
      session.setUser(user);
      if (company != null) session.setCompany(company);
      return true;
    }
    return false;
  }
}
