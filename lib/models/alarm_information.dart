class AlarmInformation {
  String? medicineName;
  List<bool>? isTakeOn;
  // 2023.03.11
  // pickedTime는 기존에 TimeOfDay? 타입의 객체였지만
  // 사용의 편이성을 고려하여 String "00:00" 형태로
  // 저장하도록 바꾼다.
  List<String>? pickedTimes;

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

  // 2023.03.10
  // SQflite는 boolean과 TimeOfDay를 처리할 수 없으므로,
  // 이를 처리할 수 있도록 filter를 거친다.
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["medicineName"] = medicineName;
    map["isTakeOnMorning"] = isTakeOnFilter(isTakeOn![0]);
    map["isTakeOnAfternoon"] = isTakeOnFilter(isTakeOn![1]);
    map["isTakeOnNight"] = isTakeOnFilter(isTakeOn![2]);
    map["pickedTimeMorning"] = pickedTimes![0];
    map["pickedTimeAfternoon"] = pickedTimes![1];
    map["pickedTimeNight"] = pickedTimes![2];
    return map;
  }

  AlarmInformation.fromMap(Map<String, dynamic> map) {
    isTakeOn = [false, false, false];
    pickedTimes = ["", "", ""];

    medicineName = map["medicineName"];
    isTakeOn![0] = convertIntToBool(map["isTakeOnMorning"]);
    isTakeOn![1] = convertIntToBool(map["isTakeOnAfternoon"]);
    isTakeOn![2] = convertIntToBool(map["isTakeOnNight"]);
    pickedTimes![0] = map["pickedTimeMorning"];
    pickedTimes![1] = map["pickedTimeAfternoon"];
    pickedTimes![2] = map["pickedTimeNight"];
  }

  bool convertIntToBool(int value) {
    if (value == 0) return false;

    return true;
  }
}
