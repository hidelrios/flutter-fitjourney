import 'package:hive/hive.dart';
import 'exercise.dart';

part 'training.g.dart';

@HiveType(typeId: 3)
class Training extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String description;

  @HiveField(2)
  DateTime dateTime;

  @HiveField(3)
  final List<Exercise> exercises;

  Training({
    required this.name,
    required this.description,
    required this.dateTime,
    required this.exercises,
  });
}
