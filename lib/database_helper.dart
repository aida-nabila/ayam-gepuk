import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  // Singleton pattern
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bookings.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE bookings(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            user TEXT, 
            date TEXT
          )
        ''');

        db.execute('''
          CREATE TABLE admin(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT,
            password TEXT
          )
        ''');

        db.execute(
            "INSERT INTO admin (email, password) VALUES ('admin@example.com', 'admin123')");
      },
    );
  }

  // CRUD operations
  Future<void> insertBooking(String user, String date) async {
    final db = await database;
    await db.insert('bookings', {'user': user, 'date': date});
  }

  Future<List<Map<String, dynamic>>> getBookings() async {
    final db = await database;
    return db.query('bookings');
  }

  Future<void> updateBooking(int id, String user, String date) async {
    final db = await database;
    await db.update(
      'bookings',
      {'user': user, 'date': date},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteBooking(int id) async {
    final db = await database;
    await db.delete('bookings', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> adminLogin(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'admin',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty;
  }
}
