import 'package:hive/hive.dart';

part 'meal.g.dart';

@HiveType(typeId: 0)
class Meal {
  @HiveField(0)
  String name;

  @HiveField(1)
  String description;

  @HiveField(2)
  int calories;

  @HiveField(3)
  double protein;

  @HiveField(4)
  double carbohydrates;

  @HiveField(5)
  double fats;

  @HiveField(6)
  DateTime dateTime;

  @HiveField(7)
  bool isInDiet;

  @HiveField(8)
  String? imagePath;

  Meal({
    required this.name,
    required this.description,
    required this.calories,
    required this.protein,
    required this.carbohydrates,
    required this.fats,
    required this.dateTime,
    required this.isInDiet,
    this.imagePath,
  });
}
