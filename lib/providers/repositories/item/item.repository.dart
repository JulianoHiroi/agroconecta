import 'package:agroconecta/providers/database/database.dart';
import 'package:agroconecta/providers/repositories/item/repository.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:agroconecta/domain/models/item.dart';

class ItemRepository extends ChangeNotifier implements ItemRepositoryBase {
  @override
  Future<void> insertItem(Item item) async {
    final db = await DB.instance.database;
    await db.insert(
      Item.SQLITE_TABLE_NAME,
      item.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<Item>> getAllItems() async {
    final db = await DB.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Item.SQLITE_TABLE_NAME,
    );
    return List.generate(maps.length, (i) => Item.fromJson(maps[i]));
  }

  @override
  Future<Item?> getItemById(String id) async {
    final db = await DB.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Item.SQLITE_TABLE_NAME,
      where: '${Item.SQLITE_COLUMN_ID} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Item.fromJson(maps.first);
    }
    return null;
  }

  @override
  Future<void> updateItem(Item item) async {
    final db = await DB.instance.database;
    await db.update(
      Item.SQLITE_TABLE_NAME,
      item.toJson(),
      where: '${Item.SQLITE_COLUMN_ID} = ?',
      whereArgs: [item.id],
    );
  }

  @override
  Future<void> deleteItem(String id) async {
    final db = await DB.instance.database;
    await db.delete(
      Item.SQLITE_TABLE_NAME,
      where: '${Item.SQLITE_COLUMN_ID} = ?',
      whereArgs: [id],
    );
  }
}
