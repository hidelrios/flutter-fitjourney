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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Informações Básicas'),
              _buildTextField('Nome', 'Insira o nome da refeição', (value) {
                _name = value!;
              }),
              _buildTextField('Descrição', 'Insira uma descrição', (value) {
                _description = value!;
              }),
              SizedBox(height: 16),
              _buildSectionTitle('Nutrientes'),
              _buildNutrientField('Calorias', (value) {
                _calories = int.parse(value!);
              }),
              _buildNutrientField('Proteínas (g)', (value) {
                _protein = double.parse(value!);
              }),
              _buildNutrientField('Carboidratos (g)', (value) {
                _carbohydrates = double.parse(value!);
              }),
              _buildNutrientField('Gorduras (g)', (value) {
                _fats = double.parse(value!);
              }),
              SizedBox(height: 16),
              _buildSectionTitle('Detalhes da Refeição'),
              ListTile(
                title: Text('Data e Hora'),
                subtitle: Text('${_dateTime.toLocal()}'.split(' ')[0] +
                    ' ${_dateTime.hour}:${_dateTime.minute}'),
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
              _buildSectionTitle('Imagem da Refeição'),
              _image == null
                  ? ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(Icons.photo),
                      label: Text('Adicionar Imagem'),
                    )
                  : Column(
                      children: [
                        Image.file(
                          _image!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon: Icon(Icons.photo),
                          label: Text('Alterar Imagem'),
                        ),
                      ],
                    ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    Function(String?) onSaved,
  ) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, $hint';
        }
        return null;
      },
      onSaved: onSaved,
    );
  }

  Widget _buildNutrientField(String label, Function(String?) onSaved) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira o valor de $label';
        }
        return null;
      },
      onSaved: onSaved,
    );
  }
}
