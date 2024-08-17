import 'package:flutter/material.dart';
import 'screens/exercises/exercises_home.dart';
import 'screens/home/home.dart';
import 'screens/meals/meal_tracking_home.dart';
import 'screens/workoutplans/workoutplans.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(), // Tela inicial
    WorkoutPlansScreen(),
    ExercisesScreen(),
    MealsTrackingScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitJourney',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('FitJourney'),
          centerTitle: true,
        ),
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center),
              label: 'Treinos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_add),
              label: 'Exercícios',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant),
              label: 'Refeições',
            ),
          ],
        ),
      ),
    );
  }
}
