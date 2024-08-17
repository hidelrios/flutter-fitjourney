import 'package:flutter/material.dart';
import 'package:fitjourney/src/models/exercise.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;

  ExerciseDetailScreen({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Detalhes do Exercício',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Séries:',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          '${exercise.numberOfSets}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Repetições:',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          '${exercise.numberOfReps}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tempo de Descanso:',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          '${exercise.restTime} s',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Divider(color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Categoria:',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Chip(
                      label: Text(
                        exercise.category,
                        style: TextStyle(fontSize: 16),
                      ),
                      backgroundColor: Colors.blueAccent.withOpacity(0.1),
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            
          ],
        ),
      ),
    );
  }
}
