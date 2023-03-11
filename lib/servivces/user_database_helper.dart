import 'package:my_medicine_checking_app/models/alarm_information.dart';

import 'database_helper.dart';

class UserDatabaseHelper {
  // database_helpder에서 AlarmInformation라고 만들었음.
  static String tableName = "AlarmInformation";

  static Future<void> createAlarmInformation(
      AlarmInformation alarmInformation) async {
    var database = await DatabaseHelper.instance.database;
    await database!.insert(tableName, alarmInformation.toMap());
  }

  static Future<List<Map<String, dynamic>>> getAlarmInformation() async {
    var database = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> list =
        await database!.rawQuery("SELECT * FROM $tableName");

    List<Map<String, dynamic>> alarmInformationList = [];

    // AlarmInformation 형태로 바뀌도록 map해야 함!
    for (var element in list) {
      var alarmInformation = AlarmInformation.fromMap(element);
      alarmInformationList.add(alarmInformation);
    }

    return alarmInformationList;
  }

  static Future<void> updateAlarmInformation(
      AlarmInformation alarmInformation) async {
    var database = await DatabaseHelper.instance.database;
    await database!.update(
      tableName,
      alarmInformation.toMap(),
      where: 'medicineName = ?',
      whereArgs: [alarmInformation.medicineName],
    );
  }

  static Future<void> deleteAlarmInformation(String medicineName) async {
    var database = await DatabaseHelper.instance.database;
    await database!.delete(
      tableName,
      where: 'medicineName = ?',
      whereArgs: [medicineName],
    );
  }
}
