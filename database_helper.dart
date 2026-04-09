import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:emotion_diary_app/models/diary_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('diary_v2.db'); // Đổi tên file db để reset
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE diaries (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT, 
          emotion TEXT, 
          score INTEGER, 
          content TEXT, 
          imagePath TEXT, 
          location TEXT
        )
      ''');
    });
  }

  Future<int> insert(Diary diary) async => await (await instance.database).insert('diaries', diary.toMap());

  Future<List<Diary>> getAllDiaries() async {
    final db = await instance.database;
    final result = await db.query('diaries', orderBy: 'date DESC');
    return result.map((json) => Diary.fromMap(json)).toList();
  }

  Future<int> delete(int id) async => await (await instance.database).delete('diaries', where: 'id = ?', whereArgs: [id]);
}