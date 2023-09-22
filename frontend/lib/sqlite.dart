import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'parcial_movil_prueba.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE favoritos(id INTEGER PRIMARY KEY, foto TEXT, nombre TEXT, vendedor TEXT, calificacion TEXT, estrella INTEGER)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    List<Map<String, dynamic>> existingData = await db.query(
      table,
      where: 'nombre = ?',
      whereArgs: [data['nombre']],
    );
    if (existingData.isNotEmpty) {
      return;
    }
    await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> delete(String table, String name) async {
    final db = await DBHelper.database();
    await db.delete(
      table,
      where: 'nombre = ?',
      whereArgs: [name],
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }
}
