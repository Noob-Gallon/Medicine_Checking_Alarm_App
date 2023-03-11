import 'package:flutter/material.dart';

class AlarmInformation {
  String? medicineName;
  List<bool>? isTakeOn;
  List<TimeOfDay?>? pickedTimes;

  AlarmInformation({
    required this.medicineName,
    required this.isTakeOn,
    required this.pickedTimes,
  });

  int isTakeOnFilter(bool value) {
    if (value == true) {
      return 1;
    } else {
      return 0;
    }
  }

  String pickedTimesFilter(TimeOfDay? value) {
    return value.toString().substring(10, 15);
  }

  // 2023.03.10
  // SQflite는 boolean과 TimeOfDay를 처리할 수 없으므로,
  // 이를 처리할 수 있도록 filter를 거친다.
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["medicineName"] = medicineName;
    map["isTakeOnMorning"] = isTakeOnFilter(isTakeOn![0]);
    map["isTakeOnAfternoon"] = isTakeOnFilter(isTakeOn![1]);
    map["isTakeOnNight"] = isTakeOnFilter(isTakeOn![2]);
    map["pickedTimeMorning"] = pickedTimesFilter(pickedTimes![0]);
    map["pickedTimeAfternoon"] = pickedTimesFilter(pickedTimes![1]);
    map["pickedTimeNight"] = pickedTimesFilter(pickedTimes![2]);
    return map;
  }

  AlarmInformation.fromMap(Map<String, dynamic> map) {
    isTakeOn = [false, false, false];
    pickedTimes = [TimeOfDay.now(), TimeOfDay.now(), TimeOfDay.now()];

    medicineName = map["medicineName"];
    isTakeOn![0] = map["isTakeOnMorning"] ? true : false;
    isTakeOn![1] = map["isTakeOnAfternoon"] ? true : false;
    isTakeOn![2] = map["isTakeOnNight"] ? true : false;
    pickedTimes![0] = map["pickedTimeMorning"];
  }
}
