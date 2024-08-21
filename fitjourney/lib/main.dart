import 'package:fitjourney/src/models/training.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'src/app.dart';
import 'src/models/meal.dart';
import 'src/models/exercise.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialize o Hive com Hive Flutter
  await Hive.initFlutter();

  // Registre o adaptador do modelo Meal
  Hive.registerAdapter(MealAdapter());

  // Registre o adaptador do modelo Exercise
  Hive.registerAdapter(ExerciseAdapter());

  // Registre o adaptador do modelo Workout
  // Hive.registerAdapter(WorkoutAdapter());

  Hive.registerAdapter(TrainingAdapter());

  // Abra a box para armazenar refeições
  await Hive.openBox<Meal>('mealsBox');
  
  // Abra a box para armazenar exercícios
  await Hive.openBox<Exercise>('exercisesBox');

  await Hive.openBox<Training>('trainingBox');

  // Abra a box para armazenar treinos
  // await Hive.openBox<Workout>('workoutsBox');

  runApp(App());
}
