import 'package:fitjourney/src/screens/exercises/exercises_create.dart';
import 'package:fitjourney/src/screens/exercises/exercises_detail.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/exercise.dart';

class ExercisesScreen extends StatefulWidget {
  @override
  _ExercisesScreenState createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  late Future<Box<Exercise>> _exercisesBoxFuture;

  @override
  void initState() {
    super.initState();
    _exercisesBoxFuture = Hive.openBox<Exercise>('exercisesBox');
  }

  void _addNewExercise() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ExerciseRegistrationScreen(
          onExerciseAdded: (exercise) {
            setState(() {
              _exercisesBoxFuture.then((box) => box.add(exercise));
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Exercícios'),
        centerTitle: true,
      ),
      body: FutureBuilder<Box<Exercise>>(
        future: _exercisesBoxFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar exercícios.'));
          }

          final box = snapshot.data;

          if (box == null || box.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Nenhum exercício registrado ainda.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _addNewExercise,
                    child: Text('Adicionar Novo Exercício'),
                  ),
                ],
              ),
            );
          }

          return ValueListenableBuilder<Box<Exercise>>(
            valueListenable: box.listenable(),
            builder: (context, box, _) {
              return ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {
                  final exercise = box.getAt(index)!;
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        exercise.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text('Séries: ${exercise.numberOfSets}'),
                          Text('Repetições: ${exercise.numberOfReps}'),
                          Text('Tempo de descanso: ${exercise.restTime}s'),
                          SizedBox(height: 8),
                          Text(
                            'Categoria: ${exercise.category}',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                ExerciseDetailScreen(exercise: exercise),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewExercise,
        child: Icon(Icons.add),
        tooltip: 'Adicionar Exercício',
                backgroundColor: Colors.blue,

      ),
    );
  }
}
