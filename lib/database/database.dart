import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'restaurantpack.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE users ('
      'userid INTEGER PRIMARY KEY AUTOINCREMENT, '
      'name TEXT NOT NULL, '
      'email TEXT NOT NULL, '
      'phone TEXT NOT NULL, '
      'username TEXT NOT NULL UNIQUE, '
      'password TEXT NOT NULL'
      ')',
    );

    await db.execute(
      'CREATE TABLE menubook ('
      'bookid INTEGER PRIMARY KEY AUTOINCREMENT, '
      'userid INTEGER NOT NULL, '
      'bookdate TEXT NOT NULL, '
      'booktime TEXT NOT NULL, '
      'eventdate TEXT NOT NULL, '
      'eventtime TEXT NOT NULL, '
      'menupackage TEXT NOT NULL, '
      'numguest INTEGER NOT NULL, '
      'packageprice REAL NOT NULL, '
      'FOREIGN KEY (userid) REFERENCES users(userid) ON DELETE CASCADE'
      ')',
    );

    await db.execute(
      'CREATE TABLE administrator ('
      'adminid INTEGER PRIMARY KEY AUTOINCREMENT, '
      'username TEXT NOT NULL UNIQUE, '
      'password TEXT NOT NULL'
      ')',
    );
  }

  // Methods for managing 'users'
  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert('users', user,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

  Future<List<Map<String, dynamic>>> getBookingsByUserId(int userId) async {
    final db = await database;
    return db.query(
      'menubook', // Replace with your actual table name
      where: 'userid = ?',
      whereArgs: [userId],
    );
  }

  Future<Map<String, dynamic>?> getUserById(int userId) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'userid = ?',
      whereArgs: [userId],
    );

    return result.isNotEmpty ? result.first : null;
  }

  Future<void> updateUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.update(
      'users',
      user,
      where: 'userid = ?',
      whereArgs: [user['userid']],
    );
  }

  Future<void> deleteBooking(int bookId) async {
    final db = await database;
    await db.delete(
      'menubook',
      where: 'bookid = ?',
      whereArgs: [bookId],
    );
  }

  Future<void> insertAdministrator(String username, String password) async {
    final db = await database;

    await db.insert(
      'administrator',
      {
        'username': username,
        'password': password,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> addAdmin(String username, String password) async {
    await insertAdministrator(username, password);
  }

  // Methods for managing 'menubook'
  Future<int> insertMenuBook(Map<String, dynamic> menubook) async {
    final db = await database;
    return await db.insert('menubook', menubook,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getMenuBooks() async {
    final db = await database;
    return await db.query('menubook');
  }

  Future<List<Map<String, dynamic>>> getAllBookings() async {
    final db = await database;
    return await db
        .query('menubook'); // Replace with your actual bookings table name
  }

  // Methods for managing 'administrator'
  Future<List<Map<String, dynamic>>> getAdministrators() async {
    final db = await database;
    return await db.query('administrator');
  }

  // Login method
  Future<Map<String, dynamic>?> login(
      String emailInput, String passwordInput) async {
    final db = await database;

    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [emailInput.trim()],
    );

    if (result.isNotEmpty) {
      final storedPassword = result.first['password'];

      if (passwordInput.trim() == storedPassword) {
        return result.first;
      }
    }
    return null;
  }

  Future<void> insertBooking(String user, String date) async {
    final db = await database;
    await db.insert('bookings', {'user': user, 'date': date});
  }

  Future<List<Map<String, dynamic>>> getBookings() async {
    final db = await database;
    return db.query('bookings');
  }

  // Methods for managing bookings
  Future<List<Map<String, dynamic>>> getAllCustomerBookings() async {
    final db = await database;
    try {
      return await db.query(
        'menubook',
        orderBy: 'eventdate ASC, eventtime ASC',
      );
    } catch (e) {
      print('Error fetching customer bookings: $e');
      return [];
    }
  }

  Future<void> updateBookingDetails({
    required int bookId,
    required int userId,
    required String eventDate,
    required String eventTime,
    required int numGuest,
  }) async {
    final db = await database;
    try {
      await db.update(
        'menubook',
        {
          'userid': userId,
          'eventdate': eventDate,
          'eventtime': eventTime,
          'numguest': numGuest,
        },
        where: 'bookid = ?',
        whereArgs: [bookId],
      );
    } catch (e) {
      print('Error updating booking: $e');
    }
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

  Future<bool> adminLogin(String username, String password) async {
    if (username == 'admin' && password == 'password') {
      return true; // Simulate successful login
    }
    return false; // Simulate failed login
  }

  // Logout function for admin
  Future<void> logout() async {
    // Clear any session data or perform any necessary cleanup
    // This is a placeholder for actual logout logic
    print('Admin logged out successfully.');
  }

  Future<void> updateBookingFull(Map<String, dynamic> booking) async {
    final db = await database;
    try {
      await db.update(
        'menubook',
        {
          'userid': booking['userid'],
          'bookdate': booking['bookdate'],
          'booktime': booking['booktime'],
          'eventdate': booking['eventdate'],
          'eventtime': booking['eventtime'],
          'menupackage': booking['menupackage'],
          'numguest': booking['numguest'],
          'packageprice': booking['packageprice'],
        },
        where: 'bookid = ?',
        whereArgs: [booking['bookid']],
      );
    } catch (e) {
      print('Error updating booking: $e');
    }
  }
}
