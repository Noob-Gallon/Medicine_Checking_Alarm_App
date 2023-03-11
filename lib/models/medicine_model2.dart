import 'package:flutter/material.dart';

class MedicineModel {
  String? name;
  List<bool>? isTakeOn;
  List<TimeOfDay?>? pickedTimes;

  MedicineModel({
    required this.name,
    required this.isTakeOn,
    required this.pickedTimes,
  });
}
