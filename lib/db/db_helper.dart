import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/task.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = "tasks";

  static Future<void> initDB() async {
    // if it's not null, it means it already been initialized.
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + 'tasks.db';
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) {
          // Creating a new table.
          return db.execute(
            "CREATE TABLE $_tableName("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "title STRING, note TEXT, date STRING, "
            "startTime STRING, "
            "remind INTEGER, repeat STRING, "
            "color INTEGER, "
            "isCompleted INTEGER)",
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Task? task) async {
    print("insert function called");
    // it returns the id of the last inserted row, 0 if it fails to insert it.
    return await _db?.insert(_tableName, task!.toJson()) ?? 1;
  }

  // returns all the tasks in the table.
  static Future<List<Map<String, dynamic>>> query() async {
    print("query function called");
    return await _db!.query(_tableName);
  }

  static Future<int> update(Task task) async {
    return await _db!.update(_tableName, task!.toJson(),
        where: "id = ?", whereArgs: [task.id]);
  }

  static updateIsCompleted(int id, int isCompleted) async {
    print("update isCompleted function called");
    // return the number of changes made.
    return await _db!.rawUpdate('''
      UPDATE tasks
      SET isCompleted = ? 
      WHERE id = ?
    ''', [isCompleted, id]);
  }

  static delete(Task task) async {
    print("delete function called");
    return await _db!.delete(_tableName, where: "id = ?", whereArgs: [task.id]);
  }
}
