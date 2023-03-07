import 'dart:io';

import 'package:firebase_demo/models/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/**
 * Base de datos Local
 */
class LocalDatabase {
  static Database? _dataBase;

  static final LocalDatabase db = LocalDatabase._();
  LocalDatabase._();

  Future<Database> get database async {
    if (_dataBase == null) {
      _dataBase = await initDB();
    }
    return _dataBase!;
  }

  Future<Database> initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, 'Users.db');
    print(path);

    return await openDatabase(
      path,
      version: 1,
      onOpen: ((db) {}),
      onCreate: (Database db, version) async {
        await db.execute('''
        CREATE TABLE Users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          email TEXT,
          address TEXT,
          phone TEXT,
          photo TEXT
        )
        ''');
      },
    );
  }

  Future<int> insertRawUser(User nouUser) async {
    final name = nouUser.name;
    final email = nouUser.email;
    final address = nouUser.address;
    final phone = nouUser.phone;
    final photo = nouUser.photo;

    final db = await database;
    final res = await db
        .rawInsert('''INSERT INTO Users (name, email, address, phone, photo) 
        VALUES ($name, $email, $address, $phone, $photo)
        ''');
    print(res);
    return res;
  }

  Future<int> insertUser(User nouUser) async {
    final db = await database;
    final res = await db.insert("Users", nouUser.toMap());
    return res;
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final res = await db.query("Users");
    return res.isNotEmpty ? res.map((e) => User.fromMap(e)).toList() : [];
  }

  Future<User?> getUserById(int id) async {
    final db = await database;
    final res = await db.query("Users", where: 'id = ?', whereArgs: [id]);

    if (res.isNotEmpty) {
      return User.fromMap(res.first);
    }
    return null;
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    final res = await db
        .update("Users", user.toMap(), where: 'id = ?', whereArgs: [user.id]);

    return res;
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    final res = await db.delete('Users', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteUsers() async {
    final db = await database;
    final res = await db.rawDelete('''
        DELETE FROM Users
        ''');
    return res;
  }
}
