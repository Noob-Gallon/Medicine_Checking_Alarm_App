class MedicineModel {
  final String name, description;
  final bool takeOnMorning, takeOnAfternoon, takeOnNight;

  MedicineModel({
    required this.name,
    required this.description,
    required this.takeOnMorning,
    required this.takeOnAfternoon,
    required this.takeOnNight,
  });
}
