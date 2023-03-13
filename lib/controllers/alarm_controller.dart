import 'package:get/get.dart';
import 'package:my_medicine_checking_app/models/alarm_information.dart';

import '../servivces/user_database_helper.dart';

class AlarmController extends GetxController {
  // alarm을 보관하는 객체
  var medicineAlarms = <AlarmInformation>[].obs;

  // alarm의 개수를 return하는 getter
  int get length => medicineAlarms.length;

  // 이를 통해 alarms에 새로운 alarmInformation을 추가한다.
  void addAlarm(AlarmInformation alarmInformation) {
    medicineAlarms.add(alarmInformation);
    UserDatabaseHelper.createAlarmInformation(alarmInformation);
  }

  void delAlarm(int index) {
    UserDatabaseHelper.deleteAlarmInformation(
        medicineAlarms[index].medicineName!);
    medicineAlarms.removeAt(index);
  }

  void updateAlarm(
      int index, AlarmInformation alarmInformation, String prevName) {
    medicineAlarms[index] = alarmInformation;
    UserDatabaseHelper.updateAlarmInformation(alarmInformation, prevName);
  }

  // 2023.03.14
  // Controller가 생성될 때 자동으로 수행되는 onInit 메서드 override.
  // 이를 통해 Controller가 생성될 때 DB로부터 데이터를 가져오고
  // 이를 medicineAlarms에 저장한다.
  @override
  void onInit() {
    super.onInit();
    print('alarm_controller on init is executed...');
    fetchAlarmsFromDB();
  }

  // 위젯이 화면에 다 그려진 후 실행되는 이벤트 메서드.
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  // 2023.03.14
  // DB에서 AlarmInformation을 가져오는 fetch method.
  // UserDatabaseHelper는 static method로 선언되어 있으므로
  // instance 없이 접근이 가능하다.
  void fetchAlarmsFromDB() async {
    print('fetchAlarmsFromDB is executed...');
    List<AlarmInformation> dataFromDB =
        await UserDatabaseHelper.getAlarmInformation();
    print('fetching is done in fetchAlarmsFromDB');

    // 2023.03.14
    // assignAll을 이용하여 medicineAlarms의 값을 가져온 데이터로 대체한다.
    // 데이터가 변경되면, 컨트롤러가 이를 구독하고 있는 Listener들에게 알려주게 되고
    // 이를 통해 구독된 부분만 UI가 업데이트 된다.
    medicineAlarms.assignAll(dataFromDB);
  }
}
