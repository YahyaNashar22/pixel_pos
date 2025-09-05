import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _dbName = 'pixel_pos.db';
  static const _dbVersion = 1;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    debugPrint("📂 Database path: $path");

    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // * Create tables

    // create company table
    await db.execute('''
CREATE TABLE company(
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT NOT NULL,
logo TEXT
)
''');

    // create users table
    await db.execute('''
CREATE TABLE users (
id INTEGER PRIMARY KEY AUTOINCREMENT,
username TEXT NOT NULL,
password TEXT NOT NULL,
role TEXT NOT NULL
)
''');

    // create categories table
    await db.execute('''
CREATE TABLE categories(
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT NOT NULL
)
''');

    // create products table
    await db.execute('''
CREATE TABLE products(
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT NOT NULL,
price DOUBLE NOT NULL,
category_id INTEGER NOT NULL,
FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE CASCADE
)
''');

    // create invoices table
    await db.execute('''
CREATE TABLE invoices(
id INTEGER PRIMARY KEY AUTOINCREMENT,
number INTEGER NOT NULL,
total DOUBLE NOT NULL
)
''');

    // create sale_orders table
    await db.execute('''
CREATE TABLE sale_orders(
id INTEGER PRIMARY KEY AUTOINCREMENT,
product_id INTEGER NOT NULL,
invoice_id INTEGER NOT NULL,
FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE,
FOREIGN KEY (invoice_id) REFERENCES invoices (id) ON DELETE CASCADE
)
''');
  }
}
