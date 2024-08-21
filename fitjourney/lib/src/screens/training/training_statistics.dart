import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/training.dart';

class TrainingStatistics extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<TrainingStatistics> {
  late Box<Training> _trainingBox;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    _trainingBox = await Hive.openBox<Training>('trainingBox');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estatísticas dos Treinos'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<Training>>(
        valueListenable: Hive.box<Training>('trainingBox').listenable(),
        builder: (context, Box<Training> box, _) {
          if (box.isEmpty) {
            return Center(
              child: Text(
                'Nenhum treino registrado ainda.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final totalTrainings = box.length;
          final totalExercises = box.values.fold<int>(0, (sum, training) => sum + training.exercises.length);
          final averageExercisesPerTraining = totalTrainings > 0 ? totalExercises / totalTrainings : 0;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resumo Geral',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                _buildStatisticCard(
                  'Total de Treinos',
                  '$totalTrainings',
                ),
                _buildStatisticCard(
                  'Total de Exercícios',
                  '$totalExercises',
                ),
                _buildStatisticCard(
                  'Média de Exercícios por Treino',
                  '${averageExercisesPerTraining.toStringAsFixed(2)}',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatisticCard(String title, String value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          value,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
