import 'package:agroconecta/data/models/item.dart';
import 'package:agroconecta/data/models/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  DB._();
  static final DB instance = DB._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase(); // Corrigido aqui
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'agroconecta.db');
    // APENAS PARA DESENVOLVIMENTO — apaga o banco antigo
    print('Deleting old database at $path');
    // await deleteDatabase(path);

    return await openDatabase(
      join(await getDatabasesPath(), 'agroconecta.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Criação das tabelas
    print('Creating tables...');
    await db.execute(Item.SQLITE_CREATE_TABLE);
    await db.execute(User.SQLITE_CREATE_TABLE);
  }
}
