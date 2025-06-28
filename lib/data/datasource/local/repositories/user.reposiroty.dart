import 'package:agroconecta/data/datasource/local/database.dart';
import 'package:agroconecta/data/interfaces/repository.dart';
import 'package:agroconecta/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class UserRepository extends ChangeNotifier implements UserRepositoryBase {
  @override
  Future<void> insertUser(User user) async {
    final db = await DB.instance.database;
    await db.insert(
      User.SQLITE_TABLE_NAME,
      _toJson(user),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<User>> getAllUsers() async {
    final db = await DB.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      User.SQLITE_TABLE_NAME,
    );
    return List.generate(maps.length, (i) => _fromJson(maps[i]));
  }

  @override
  Future<User?> getUserById(String id) async {
    final db = await DB.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      User.SQLITE_TABLE_NAME,
      where: '${User.SQLITE_COLUMN_ID} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return _fromJson(maps.first);
    }
    return null;
  }

  @override
  Future<void> updateUser(User user) async {
    final db = await DB.instance.database;
    await db.update(
      User.SQLITE_TABLE_NAME,
      _toJson(user),
      where: '${User.SQLITE_COLUMN_ID} = ?',
      whereArgs: [user.id],
    );
  }

  @override
  Future<void> deleteUser(String id) async {
    final db = await DB.instance.database;
    await db.delete(
      User.SQLITE_TABLE_NAME,
      where: '${User.SQLITE_COLUMN_ID} = ?',
      whereArgs: [id],
    );
  }

  /// Serializa para salvar no SQLite (converte DateTime para string)
  Map<String, dynamic> _toJson(User user) {
    return {
      User.SQLITE_COLUMN_ID: user.id,
      User.SQLITE_COLUMN_NAME: user.name,
      User.SQLITE_COLUMN_EMAIL: user.email,
      User.SQLITE_COLUMN_GENDER: user.gender,
      User.SQLITE_COLUMN_DATE_OF_BIRTH: user.dateOfBirth.toIso8601String(),
    };
  }

  /// Desserializa o JSON lido do SQLite para um objeto User
  User _fromJson(Map<String, dynamic> map) {
    return User(
      id: map[User.SQLITE_COLUMN_ID],
      name: map[User.SQLITE_COLUMN_NAME],
      email: map[User.SQLITE_COLUMN_EMAIL],
      gender: map[User.SQLITE_COLUMN_GENDER],
      dateOfBirth: DateTime.parse(map[User.SQLITE_COLUMN_DATE_OF_BIRTH]),
    );
  }
}
