import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/training.dart';
import 'training_create.dart';
import 'training_detail.dart';

class TrainingScreen extends StatefulWidget {
  @override
  _TrainingTrackingScreenState createState() => _TrainingTrackingScreenState();
}

class _TrainingTrackingScreenState extends State<TrainingScreen> {
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

  void _addNewTraining() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TrainingRegistrationScreen(
          onTrainingAdded: (training) {
            setState(() {
              _trainingBox.add(training);
            });
          },
        ),
      ),
    );
  }

  void _deleteTraining(int index) async {
    await _trainingBox.deleteAt(index);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Treino excluído com sucesso!'),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Excluir Treino'),
          content: Text('Você tem certeza que deseja excluir este treino?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
                _deleteTraining(index); // Chama a função de deleção
              },
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monitoramento de Treinos'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<Training>>(
        valueListenable: Hive.box<Training>('trainingBox').listenable(),
        builder: (context, Box<Training> box, _) {
          if (box.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Nenhum treino registrado ainda.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _addNewTraining,
                    child: Text('Adicionar Novo Treino'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final training = box.getAt(index)!;
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(training.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Descrição: ${training.description}'),
                      Text(
                        'Data: ' +
                            '${training.dateTime.toLocal()}'.split(' ')[0] +
                            ' ${training.dateTime.hour}:${training.dateTime.minute}',
                      ),
                      Text('Exercícios: ${training.exercises.length}'),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TrainingDetailScreen(
                          training: training,
                          onDelete: () {
                            _showDeleteConfirmationDialog(context, index);
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTraining,
        child: Icon(Icons.add),
        tooltip: 'Adicionar Treino',
        backgroundColor: Colors.blue,
      ),
    );
  }
}
