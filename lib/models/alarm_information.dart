import 'package:flutter/material.dart';

class AlarmInformation {
  final String medicineName;
  final List<bool> isTakeOn;
  final List<TimeOfDay?> pickedTimes;

  AlarmInformation({
    required this.medicineName,
    required this.isTakeOn,
    required this.pickedTimes,
  });
}
