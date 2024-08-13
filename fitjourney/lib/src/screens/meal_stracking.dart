import 'package:flutter/material.dart';
import 'meal_stracking_create.dart'; // Importar a tela de cadastro de refeições

class MealsTrackingScreen extends StatefulWidget {
  @override
  _MealsTrackingScreenState createState() => _MealsTrackingScreenState();
}

class _MealsTrackingScreenState extends State<MealsTrackingScreen> {
  // Lista fictícia de refeições. Você pode substituir isso por uma fonte de dados real.
  final List<Map<String, dynamic>> _meals = [];

  void _addNewMeal() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MealRegistrationScreen(
          onMealAdded: (meal) {
            setState(() {
              _meals.add(meal);
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
        title: Text('Monitoramento de Refeições'),
        centerTitle: true,
      ),
      body: _meals.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Nenhuma refeição registrada ainda.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _meals.length,
              itemBuilder: (context, index) {
                final meal = _meals[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: meal['isInDiet'] ? Colors.green : Colors.red,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(meal['name']),
                    subtitle: Text(
                      'Horário: ${meal['dateTime'].toLocal()}'.split(' ')[0] + ' ${meal['dateTime'].hour}:${meal['dateTime'].minute}',
                    ),
                    isThreeLine: false,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewMeal,
        child: Icon(Icons.add),
        tooltip: 'Adicionar Refeição',
      ),
    );
  }
}
