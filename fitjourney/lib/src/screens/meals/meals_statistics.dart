import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../models/meal.dart';

class MealStatisticsScreen extends StatefulWidget {
  @override
  _MealStatisticsScreenState createState() => _MealStatisticsScreenState();
}

class _MealStatisticsScreenState extends State<MealStatisticsScreen> {
  late Box<Meal> _mealsBox;

  @override
  void initState() {
    super.initState();
    _mealsBox = Hive.box<Meal>('mealsBox');
  }

  int _getTotalMeals() {
    return _mealsBox.length;
  }

  int _getMealsInDiet() {
    return _mealsBox.values.where((meal) => meal.isInDiet).length;
  }

  int _getMealsOutOfDiet() {
    return _mealsBox.values.where((meal) => !meal.isInDiet).length;
  }

  @override
  Widget build(BuildContext context) {
    int totalMeals = _getTotalMeals();
    int mealsInDiet = _getMealsInDiet();
    int mealsOutOfDiet = _getMealsOutOfDiet();

    return Scaffold(
      appBar: AppBar(
        title: Text('Estatísticas de Refeições'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total de Refeições',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '$totalMeals',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              color: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Refeições dentro da Dieta',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '$mealsInDiet',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              color: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Refeições fora da Dieta',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '$mealsOutOfDiet',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
