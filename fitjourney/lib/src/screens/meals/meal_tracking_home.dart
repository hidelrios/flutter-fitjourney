import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'meal_tracking_create.dart';
import 'meal_tracking_detail.dart';
import '../../models/meal.dart';

import 'dart:io';
class MealsTrackingScreen extends StatefulWidget {
  @override
  _MealsTrackingScreenState createState() => _MealsTrackingScreenState();
}

class _MealsTrackingScreenState extends State<MealsTrackingScreen> {
  late Box<Meal> _mealsBox;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    _mealsBox = await Hive.openBox<Meal>('mealsBox');
    setState(() {});
  }

  void _addNewMeal() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MealRegistrationScreen(
          onMealAdded: (meal) {
            setState(() {
              _mealsBox.add(meal);
            });
          },
        ),
      ),
    );
  }

  void _deleteMeal(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Excluir Refeição'),
          content: Text('Você tem certeza que deseja excluir esta refeição?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _mealsBox.deleteAt(index);
                });
                Navigator.of(context).pop();
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
        title: Text('Monitoramento de Refeições'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<Meal>>(
        valueListenable: Hive.box<Meal>('mealsBox').listenable(),
        builder: (context, Box<Meal> box, _) {
          if (box.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Nenhuma refeição registrada ainda.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _addNewMeal,
                    child: Text('Adicionar Nova Refeição'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final meal = box.getAt(index)!;
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: meal.isInDiet ? Colors.green : Colors.red,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(meal.name),
                  subtitle: Text(
                    'Horário: ${meal.dateTime.toLocal()}'.split(' ')[0] +
                    ' ${meal.dateTime.hour}:${meal.dateTime.minute}',
                  ),
                  isThreeLine: false,
                  trailing: meal.imagePath != null
                      ? Image.file(
                          File(meal.imagePath!),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : null,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MealDetailScreen(
                          meal: meal,
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
        onPressed: _addNewMeal,
        child: Icon(Icons.add),
        tooltip: 'Adicionar Refeição',
      ),
    );
  }
}
