import 'package:flutter/material.dart';
import 'package:fisma_inso2/models/user.dart';
import 'dart:math';

class UserFormScreen extends StatefulWidget {
  final Function(User) onSubmit;
  final User? userToEdit;

  UserFormScreen({required this.onSubmit, this.userToEdit});

  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _apellidoController = TextEditingController();
  final _nombreController = TextEditingController();
  String _estadoSeleccionado = 'pendiente';
  String _rolSeleccionado = 'Agente Sanitario';

  @override
  void initState() {
    super.initState();
    if (widget.userToEdit != null) {
      _apellidoController.text = widget.userToEdit!.apellido;
      _nombreController.text = widget.userToEdit!.nombre;
      _estadoSeleccionado = widget.userToEdit!.estado;
      _rolSeleccionado = widget.userToEdit!.rol;
    }
  }

  void _submitForm() {
    if (_apellidoController.text.isEmpty || _nombreController.text.isEmpty) {
      return; // No permitir el envío si los campos están vacíos.
    }

    final id = widget.userToEdit?.id ?? Random().nextInt(10000).toString();

    final nuevoUsuario = User(
      id: id,
      apellido: _apellidoController.text,
      nombre: _nombreController.text,
      estado: _estadoSeleccionado,
      fechaUltimoAcceso: widget.userToEdit?.fechaUltimoAcceso ?? DateTime.now(),
      rol: _rolSeleccionado,
    );

    widget.onSubmit(nuevoUsuario);
    Navigator.of(context).pop(); // Cerrar el diálogo después de agregar o editar el usuario.
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.userToEdit == null ? 'Agregar Nuevo Usuario' : 'Editar Usuario',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _apellidoController,
            decoration: InputDecoration(
              labelText: 'Apellido',
              filled: true,
              fillColor: Colors.grey[300],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _nombreController,
            decoration: InputDecoration(
              labelText: 'Nombre',
              filled: true,
              fillColor: Colors.grey[300],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _estadoSeleccionado,
            items: [
              DropdownMenuItem(value: 'pendiente', child: Text('Pendiente')),
              DropdownMenuItem(value: 'completo', child: Text('Completo')),
            ],
            onChanged: (value) {
              setState(() {
                _estadoSeleccionado = value!;
              });
            },
            decoration: InputDecoration(
              labelText: 'Estado',
              filled: true,
              fillColor: Colors.grey[300],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _rolSeleccionado,
            items: [
              DropdownMenuItem(
                  value: 'Agente Sanitario', child: Text('Agente Sanitario')),
              DropdownMenuItem(value: 'Supervisor', child: Text('Supervisor')),
            ],
            onChanged: (value) {
              setState(() {
                _rolSeleccionado = value!;
              });
            },
            decoration: InputDecoration(
              labelText: 'Rol',
              filled: true,
              fillColor: Colors.grey[300],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: Colors.blue[800],
            ),
            child: Text(widget.userToEdit == null ? 'Agregar Usuario' : 'Actualizar Usuario'),
          ),
        ],
      ),
    );
  }
}
