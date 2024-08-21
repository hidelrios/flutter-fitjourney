import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../models/exercise.dart';
import '../meals/meals_statistics.dart';
import '../training/training_statistics.dart';
import '../../models/meal.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Meal> _mealsBox;
  late Box<Exercise> _exercisesBox;

  @override
  void initState() {
    super.initState();
    _openBoxes();
  }

  Future<void> _openBoxes() async {
    _mealsBox = await Hive.openBox<Meal>('mealsBox');
    _exercisesBox = await Hive.openBox<Exercise>('exercisesBox');
    setState(() {}); // Atualize o estado após abrir as caixas
  }

  double _getDietPercentage() {
    final totalMeals = _mealsBox.length;
    if (totalMeals == 0) return 0;
    final mealsInDiet = _mealsBox.values.where((meal) => meal.isInDiet).length;
    return (mealsInDiet / totalMeals) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela Inicial'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: Future.wait([
          Hive.openBox<Meal>('mealsBox'),
          Hive.openBox<Exercise>('exercisesBox'),
        ]),
        builder: (context, AsyncSnapshot<List<Box>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar dados.'));
          }

          final mealsBox = snapshot.data![0] as Box<Meal>;
          final exercisesBox = snapshot.data![1] as Box<Exercise>;

          final dietPercentage = _getDietPercentage();

          return Padding(
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
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TrainingStatistics(),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.greenAccent,
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
                            'Estatísticas dos Treinos',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Icon(
                            Icons.bar_chart,
                            size: 48,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Outros cards ou conteúdo podem ser adicionados aqui
              ],
            ),
          );
        },
      ),
    );
  }
}
