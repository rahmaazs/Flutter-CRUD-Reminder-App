import 'package:projectuts4/model/reminder.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  static Database? _database;

  //inisialisasi beberapa variabel yang dibutuhkan
  final String tableName = 'tableReminder';
  final String columnId = 'id';
  final String columnEvent = 'event';
  final String columnDesc = 'desc';
  final String columnDate = 'date';
  final String columnTime = 'time';
  final String columnLocation = 'location';

  DbHelper._internal();
  factory DbHelper() => _instance;

  //cek apakah database ada
  Future<Database?> get _db async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDb();
    return _database;
  }

  Future<Database?> _initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'reminder.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  //membuat tabel dan field-fieldnya
  Future<void> _onCreate(Database db, int version) async {
    var sql = "CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY, "
        "$columnEvent TEXT,"
        "$columnDesc TEXT,"
        "$columnDate TEXT,"
        "$columnTime TEXT,"
        "$columnLocation TEXT)";
    await db.execute(sql);
  }

  //insert ke database
  Future<int?> saveReminder(Reminder reminder) async {
    var dbClient = await _db;
    return await dbClient!.insert(tableName, reminder.toMap());
  }

  //read database
  Future<List?> getAllReminder() async {
    var dbClient = await _db;
    var result = await dbClient!.query(tableName, columns: [
      columnId,
      columnEvent,
      columnDesc,
      columnDate,
      columnTime,
      columnLocation
    ]);

    return result.toList();
  }

  //update database
  Future<int?> updateReminder(Reminder reminder) async {
    var dbClient = await _db;
    return await dbClient!.update(tableName, reminder.toMap(),
        where: '$columnId = ?', whereArgs: [reminder.id]);
  }

  //hapus database
  Future<int?> deleteReminder(int id) async {
    var dbClient = await _db;
    return await dbClient!
        .delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }
}
