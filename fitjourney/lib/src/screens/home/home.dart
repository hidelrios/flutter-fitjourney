import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../meals/meals_statistics.dart';
import '../../models/meal.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Meal> _mealsBox;

  @override
  void initState() {
    super.initState();
    _mealsBox = Hive.box<Meal>('mealsBox');
  }

  double _getDietPercentage() {
    final totalMeals = _mealsBox.length;
    if (totalMeals == 0) return 0;
    final mealsInDiet = _mealsBox.values.where((meal) => meal.isInDiet).length;
    return (mealsInDiet / totalMeals) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final dietPercentage = _getDietPercentage();

    return Scaffold(
      appBar: AppBar(
        title: Text('Tela Inicial'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MealStatisticsScreen(),
                  ),
                );
              },
              child: Card(
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
                        'Porcentagem de Refeições na Dieta',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '${dietPercentage.toStringAsFixed(1)}%',
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
            ),
            // Outros cards ou conteúdo podem ser adicionados aqui
          ],
        ),
      ),
    );
  }
}
