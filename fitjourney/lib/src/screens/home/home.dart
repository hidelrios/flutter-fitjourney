import 'package:flutter/material.dart';

import '../exercises/exercises.dart';
import '../meals/meal_tracking_home.dart';
import '../workoutplans/workoutplans.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Tela de Home',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
 
  
}
