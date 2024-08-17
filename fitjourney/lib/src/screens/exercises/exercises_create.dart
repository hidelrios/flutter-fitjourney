import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../models/exercise.dart';

class ExerciseRegistrationScreen extends StatefulWidget {
  final Function(Exercise) onExerciseAdded;

  ExerciseRegistrationScreen({required this.onExerciseAdded});

  @override
  _ExerciseRegistrationScreenState createState() => _ExerciseRegistrationScreenState();
}

class _ExerciseRegistrationScreenState extends State<ExerciseRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _exerciseName = '';
  int _sets = 0;
  int _reps = 0;
  int _restTime = 0;
  String _selectedCategory = 'Pernas'; // Valor inicial

  // Lista de categorias disponíveis
  final List<String> _categories = [
    'Pernas',
    'Costas',
    'Ombros',
    'Bíceps e Tríceps',
    'Glúteos',
    'Abdômen',
  ];

  void _saveExercise() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Criar uma instância do exercício
      final newExercise = Exercise(
        name: _exerciseName,
        numberOfSets: _sets,
        numberOfReps: _reps,
        restTime: _restTime,
        category: _selectedCategory,
      );

      // Adicionar o exercício utilizando o callback
      widget.onExerciseAdded(newExercise);

      // Fechar a tela e voltar para a tela anterior
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Exercício'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome do Exercício'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do exercício';
                  }
                  return null;
                },
                onSaved: (value) => _exerciseName = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Séries'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o número de séries';
                  }
                  return null;
                },
                onSaved: (value) => _sets = int.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Repetições'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o número de repetições';
                  }
                  return null;
                },
                onSaved: (value) => _reps = int.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Tempo de Descanso (segundos)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o tempo de descanso';
                  }
                  return null;
                },
                onSaved: (value) => _restTime = int.parse(value!),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(labelText: 'Categoria'),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione uma categoria';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveExercise,
                child: Text('Cadastrar Exercício'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
