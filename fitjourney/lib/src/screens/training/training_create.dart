import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/exercise.dart';
import '../../models/training.dart';

class TrainingRegistrationScreen extends StatefulWidget {
  final Function(Training) onTrainingAdded;

  TrainingRegistrationScreen({required this.onTrainingAdded});

  @override
  _TrainingRegistrationScreenState createState() =>
      _TrainingRegistrationScreenState();
}

class _TrainingRegistrationScreenState
    extends State<TrainingRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDateTime;
  List<Exercise> _selectedExercises = [];
  late Future<Box<Exercise>> _exercisesBoxFuture;

  @override
  void initState() {
    super.initState();
    _exercisesBoxFuture = Hive.openBox<Exercise>('exercisesBox');
  }

  void _toggleExerciseSelection(Exercise exercise) {
    setState(() {
      if (_selectedExercises.contains(exercise)) {
        _selectedExercises.remove(exercise);
      } else {
        _selectedExercises.add(exercise);
      }
    });
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _saveTraining() {
    if (_formKey.currentState!.validate()) {
      if (_selectedExercises.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Por favor, selecione pelo menos um exercício.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_selectedDateTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Por favor, selecione a data e a hora.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final newTraining = Training(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        dateTime: _selectedDateTime!,
        exercises: _selectedExercises,
      );

      widget.onTrainingAdded(newTraining);
      Navigator.of(context).pop();
    }
  }

  Widget _buildExerciseItem(Exercise exercise) {
    final isSelected = _selectedExercises.contains(exercise);
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          isSelected ? Icons.check_circle : Icons.check_circle_outline,
          color: isSelected ? Colors.green : Colors.grey,
          size: 30,
        ),
        title: Text(
          exercise.name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text('Categoria: ${exercise.category}'),
            Text('Séries: ${exercise.numberOfSets}'),
            Text('Repetições: ${exercise.numberOfReps}'),
            Text('Descanso: ${exercise.restTime}s'),
          ],
        ),
        onTap: () => _toggleExerciseSelection(exercise),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Treino'),
        centerTitle: true,
      ),
      body: FutureBuilder<Box<Exercise>>(
        future: _exercisesBoxFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('Erro ao carregar exercícios.'));
          }

          final box = snapshot.data!;

          if (box.isEmpty) {
            return Center(
              child: Text(
                'Nenhum exercício disponível. Por favor, cadastre exercícios primeiro.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Informações do Treino',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nome do Treino',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.fitness_center),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor, insira o nome do treino.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Descrição do Treino',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.description),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor, insira a descrição do treino.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  ListTile(
                    title: Text(
                      _selectedDateTime == null
                          ? 'Selecionar Data e Hora'
                          : 'Data e Hora: ${_selectedDateTime!.day}/${_selectedDateTime!.month}/${_selectedDateTime!.year} ${_selectedDateTime!.hour}:${_selectedDateTime!.minute}',
                    ),
                    leading: Icon(Icons.calendar_today),
                    onTap: () => _selectDateTime(context),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Selecione os Exercícios',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: box.length,
                      itemBuilder: (context, index) {
                        final exercise = box.getAt(index)!;
                        return _buildExerciseItem(exercise);
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _saveTraining,
                      icon: Icon(Icons.save),
                      label: Text(
                        'Salvar Treino',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
