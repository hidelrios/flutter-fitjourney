import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'src/app.dart';
import 'src/models/meal.dart';
import 'src/models/exercise.dart'; // Importe o modelo Exercise

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialize o Hive com Hive Flutter
  await Hive.initFlutter();

  // Registre o adaptador do modelo Meal
  Hive.registerAdapter(MealAdapter());

  // Registre o adaptador do modelo Exercise
  Hive.registerAdapter(ExerciseAdapter());

  // Abra a box para armazenar refeições
  await Hive.openBox<Meal>('mealsBox');
  
  // Abra a box para armazenar exercícios
  await Hive.openBox<Exercise>('exercisesBox');

  runApp(App());
}
