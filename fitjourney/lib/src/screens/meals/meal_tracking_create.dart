import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:hive/hive.dart';
import '../../models/meal.dart';

class MealRegistrationScreen extends StatefulWidget {
  final Function(Meal)? onMealAdded;

  MealRegistrationScreen({this.onMealAdded});

  @override
  _MealRegistrationScreenState createState() => _MealRegistrationScreenState();
}

class _MealRegistrationScreenState extends State<MealRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  int _calories = 0;
  double _protein = 0;
  double _carbohydrates = 0;
  double _fats = 0;
  DateTime _dateTime = DateTime.now();
  bool _isInDiet = true;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Refeição'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome da refeição';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma descrição';
                  }
                  return null;
                },
                onSaved: (value) => _description = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Calorias'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o número de calorias';
                  }
                  return null;
                },
                onSaved: (value) => _calories = int.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Proteínas (g)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a quantidade de proteínas';
                  }
                  return null;
                },
                onSaved: (value) => _protein = double.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Carboidratos (g)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a quantidade de carboidratos';
                  }
                  return null;
                },
                onSaved: (value) => _carbohydrates = double.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Gorduras (g)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a quantidade de gorduras';
                  }
                  return null;
                },
                onSaved: (value) => _fats = double.parse(value!),
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text('Data e Hora da Refeição'),
                subtitle: Text('${_dateTime.toLocal()}'.split(' ')[0] + ' ${_dateTime.hour}:${_dateTime.minute}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _dateTime,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (selectedDate != null && selectedDate != _dateTime) {
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_dateTime),
                    );
                    if (selectedTime != null) {
                      setState(() {
                        _dateTime = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                      });
                    }
                  }
                },
              ),
              SizedBox(height: 16),
              SwitchListTile(
                title: Text('Está dentro da dieta?'),
                value: _isInDiet,
                onChanged: (value) {
                  setState(() {
                    _isInDiet = value;
                  });
                },
              ),
              SizedBox(height: 16),
              _image == null
                  ? ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(Icons.photo),
                      label: Text('Adicionar Imagem da Refeição'),
                    )
                  : Column(
                      children: [
                        Image.file(
                          _image!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon: Icon(Icons.photo),
                          label: Text('Alterar Imagem'),
                        ),
                      ],
                    ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final meal = Meal(
                      name: _name,
                      description: _description,
                      calories: _calories,
                      protein: _protein,
                      carbohydrates: _carbohydrates,
                      fats: _fats,
                      dateTime: _dateTime,
                      isInDiet: _isInDiet,
                      imagePath: _image?.path,
                    );
                    if (widget.onMealAdded != null) {
                      widget.onMealAdded!(meal);
                    }
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Registrar Refeição'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
