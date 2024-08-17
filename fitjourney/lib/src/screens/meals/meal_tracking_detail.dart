import 'package:flutter/material.dart';
import '../../models/meal.dart';
import 'dart:io';

class MealDetailScreen extends StatelessWidget {
  final Meal meal;
  final VoidCallback onDelete;

  MealDetailScreen({required this.meal, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Refeição'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              onDelete();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (meal.imagePath != null)
              Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(meal.imagePath!),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Card(
              elevation: 4,
              margin: EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.name,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Descrição:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      meal.description,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 4,
              margin: EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informações Nutricionais',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Calorias: ${meal.calories}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Proteínas: ${meal.protein} g',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Carboidratos: ${meal.carbohydrates} g',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Gorduras: ${meal.fats} g',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 4,
              margin: EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data e Hora',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${meal.dateTime.toLocal()}'.split(' ')[0] +
                      ' ${meal.dateTime.hour}:${meal.dateTime.minute}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Está dentro da dieta: ${meal.isInDiet ? 'Sim' : 'Não'}',
                      style: TextStyle(fontSize: 16),
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
