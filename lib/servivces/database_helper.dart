import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// 2023.03.10
// This class contains methods to create a database,
// connect to the database create tables, etc.
class DatabaseHelper {
  static const _databaseName = "medAlarm.app";
  static const _databaseVersion = 1;

  DatabaseHelper._internal();
  static final DatabaseHelper databaseHelper = DatabaseHelper._internal();
  static DatabaseHelper get instance => databaseHelper;

  static Database? _database;

  final String medicineName = "medicineName";
  final String isTakeOnMorning = "isTakeOnMorning";
  final String isTakeOnAfternoon = "isTakeOnAfternoon";
  final String isTakeOnNight = "isTakeOnNight";
  final String pickedTimeMorning = "pickedTimeMorning";
  final String pickedTimeAfternoon = "pickedTimeAfternoon";
  final String pickedTimeNight = "pickedTimeNight";

  Future<Database?> get database async {
    if (_database != null) {
      print("returns the database");
      return _database;
    }
    print("build a new database");
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE AlarmInformation("
      "$medicineName TEXT PRIMARY KEY, "
      "$isTakeOnMorning int, "
      "$isTakeOnAfternoon int, "
      "$isTakeOnNight int, "
      "$pickedTimeMorning TEXT, "
      "$pickedTimeAfternoon TEXT, "
      "$pickedTimeNight TEXT)",
    );
  }
}
