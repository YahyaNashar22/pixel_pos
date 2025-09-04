import 'package:pixel_pos/data/database_helper.dart';

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
    return result.isNotEmpty;
  }
}
