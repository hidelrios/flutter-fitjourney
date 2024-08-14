import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'src/app.dart';
import 'src/models/meal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialize o Hive com Hive Flutter
  await Hive.initFlutter();

  // Registre o adaptador do modelo Meal
  Hive.registerAdapter(MealAdapter());

  // Abra a box para armazenar refeições
  await Hive.openBox<Meal>('mealsBox');
  runApp(App());
}
