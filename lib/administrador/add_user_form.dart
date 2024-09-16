import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fisma_inso2/models/agent_model.dart';

class AddUserForm extends StatefulWidget {
  final Agent? agent;
  final Function(Agent) onSave;

  AddUserForm({this.agent, required this.onSave});

  @override
  _AddUserFormState createState() => _AddUserFormState();
}

class _AddUserFormState extends State<AddUserForm> {
  final _formKey = GlobalKey<FormState>();
  late String _id;
  late TextEditingController _nombreController;
  late TextEditingController _apellidoController;
  String _estadoDeTareas = 'Pendiente';
  late String _fechaUltimoAcceso;
  String _userType = 'Agente Sanitario';

  @override
  void initState() {
    super.initState();
    _id = widget.agent?.id ?? _generateId();
    _nombreController = TextEditingController(text: widget.agent?.nombre ?? '');
    _apellidoController = TextEditingController(text: widget.agent?.apellido ?? '');
    _estadoDeTareas = widget.agent?.estadoDeTareas ?? 'Pendiente';
    _fechaUltimoAcceso = widget.agent?.fechaUltimoAcceso ?? DateFormat('yyyy-MM-dd').format(DateTime.now());
    _userType = widget.agent?.rol ?? 'Agente Sanitario';
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    super.dispose();
  }

  String _generateId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'ID$timestamp';
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newAgent = Agent(
        id: _id,
        nombre: _nombreController.text,
        apellido: _apellidoController.text,
        estadoDeTareas: _estadoDeTareas,
        fechaUltimoAcceso: _fechaUltimoAcceso,
        informeReciente: '',
        rol: _userType,
      );
      widget.onSave(newAgent);
      Navigator.of(context).pop(); // Cierra el formulario después de guardar
    }
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
              widget.agent != null ? 'Editar Usuario' : 'Agregar Nuevo Usuario',
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
              initialValue: _id,
              enabled: false,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _nombreController,
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
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _apellidoController,
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
              initialValue: _fechaUltimoAcceso,
              enabled: false,
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
              onPressed: _submitForm,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Guardar Usuario', style: TextStyle(fontSize: 18)),
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