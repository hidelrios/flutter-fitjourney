import 'package:flutter/material.dart';

import 'exercises.dart';
import 'meal_stracking.dart';
import 'workoutplans.dart';

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
