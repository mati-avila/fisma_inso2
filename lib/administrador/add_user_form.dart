import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha

class AddUserForm extends StatefulWidget {
  @override
  _AddUserFormState createState() => _AddUserFormState();
}

class _AddUserFormState extends State<AddUserForm> {
  final _formKey = GlobalKey<FormState>();
  late String _id;
  String _nombre = '';
  String _apellido = '';
  String _estadoDeTareas = 'Pendiente';
  String _fechaUltimoAcceso = DateFormat('yyyy-MM-dd').format(DateTime.now()); // Fecha actual por defecto
  String _userType = 'Agente Sanitario';

  @override
  void initState() {
    super.initState();
    _id = _generateId();
  }

  String _generateId() {
    // Lógica simple para generar un ID único basado en el timestamp actual
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'ID${timestamp.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Agregar Nuevo Usuario',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.lightBlue),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'ID',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.perm_identity, color: Colors.lightBlue),
              ),
              initialValue: _id, // Muestra el ID generado
              enabled: false,  // Campo deshabilitado, solo visible
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person, color: Colors.lightBlue),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un nombre';
                }
                return null;
              },
              onSaved: (value) => _nombre = value!,
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Apellido',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline, color: Colors.lightBlue),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un apellido';
                }
                return null;
              },
              onSaved: (value) => _apellido = value!,
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _estadoDeTareas,
              decoration: InputDecoration(
                labelText: 'Estado de Tareas',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.task_alt, color: Colors.lightBlue),
              ),
              items: <String>['Pendiente', 'Completado']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _estadoDeTareas = newValue!;
                });
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Fecha Último Acceso',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today, color: Colors.lightBlue),
              ),
              initialValue: _fechaUltimoAcceso,  // Muestra la fecha de último acceso
              enabled: false,  // Campo deshabilitado, solo visible
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _userType,
              decoration: InputDecoration(
                labelText: 'Tipo de Usuario',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category, color: Colors.lightBlue),
              ),
              items: <String>['Agente Sanitario', 'Supervisor']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _userType = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Aquí iría la lógica para guardar el usuario
                  print('ID: $_id, Nombre: $_nombre, Apellido: $_apellido, '
                      'Estado de Tareas: $_estadoDeTareas, Fecha Último Acceso: $_fechaUltimoAcceso, Tipo: $_userType');
                  Navigator.pop(context);
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Agregar Usuario', style: TextStyle(fontSize: 18)),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
