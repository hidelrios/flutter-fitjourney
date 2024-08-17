import 'package:hive/hive.dart';

part 'exercise.g.dart';

@HiveType(typeId: 1)
class Exercise {
  @HiveField(0)
  String name;

  @HiveField(1)
  int numberOfSets;

  @HiveField(2)
  int numberOfReps;

  @HiveField(3)
  int restTime;

  @HiveField(4)
  String category;

  Exercise({
    required this.name,
    required this.numberOfSets,
    required this.numberOfReps,
    required this.restTime,
    required this.category,
  });
}
