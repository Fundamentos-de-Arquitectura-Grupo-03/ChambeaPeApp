import 'package:chambeape/infrastructure/models/users.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  static Database? _database;

  factory DbHelper() {
    return _instance;
  }

  DbHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'notes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstName TEXT,
        lastName TEXT,
        email TEXT,
        password TEXT,
        phoneNumber TEXT,
        birthdate TEXT,
        gender TEXT,
        hasPremium INTEGER,
        profilePic TEXT,
        description TEXT,
        userRole TEXT,
        isVisible TEXT,
        dni TEXT,
        insertDate TEXT
      )
    ''');
  }

  Future<int> insertUser(Users user) async {
    final db = await database;
    final Map<String, dynamic> userMap = user.toJson();
    userMap['insertDate'] = DateTime.now().toIso8601String();

    // Intenta insertar el usuario, si ya existe actualiza el registro
    try {
      int id = await db.insert('users', userMap);
      await _limitUserCount(db);
      return id;
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        await updateUser(user); // Si hay un error de clave única, actualiza el usuario existente
        return user.id!;
      } else {
        rethrow;
      }
    }
  }

  Future<List<Users>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return Users.fromJson(maps[i]);
    });
  }

  Future<int> updateUser(Users user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toJson(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> _limitUserCount(Database db) async {
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      orderBy: 'insertDate ASC',
    );

    if (result.length > 5) {
      int idToDelete = result.first['id'];
      await db.delete(
        'users',
        where: 'id = ?',
        whereArgs: [idToDelete],
      );
    }
  }
}
