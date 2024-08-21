import 'package:flutter/material.dart';
import '../../models/training.dart';

class TrainingDetailScreen extends StatelessWidget {
  final Training training;
  final VoidCallback onDelete;

  TrainingDetailScreen({
    required this.training,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Treino'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Nome do Treino'),
            _buildContentText(training.name),
            SizedBox(height: 16),
            _buildSectionTitle('Descrição'),
            _buildContentText(training.description),
            SizedBox(height: 16),
            _buildSectionTitle('Data e Hora'),
            _buildContentText(
              '${training.dateTime.toLocal()}'.split(' ')[0] +
              ' ${training.dateTime.hour.toString().padLeft(2, '0')}:${training.dateTime.minute.toString().padLeft(2, '0')}',
            ),
            SizedBox(height: 16),
            _buildSectionTitle('Exercícios'),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: training.exercises.length,
                itemBuilder: (context, index) {
                  final exercise = training.exercises[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    elevation: 2,
                    child: ListTile(
                      title: Text(
                        exercise.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Séries: ${exercise.numberOfSets} | Repetições: ${exercise.numberOfReps} | Descanso: ${exercise.restTime} segundos',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blueAccent,
      ),
    );
  }

  Widget _buildContentText(String content) {
    return Text(
      content,
      style: TextStyle(fontSize: 16, color: Colors.grey[800]),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
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
                onDelete(); // Chama a função de deleção
                Navigator.of(context).pop(); // Fecha a tela de detalhes
              },
              child: Text(
                'Excluir',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
