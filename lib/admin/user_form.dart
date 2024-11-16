import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisma_inso2/models/user.dart';

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
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();
  String _estadoSeleccionado = 'pendiente';
  String _rolSeleccionado = 'Agente Sanitario';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.userToEdit != null) {
      _apellidoController.text = widget.userToEdit!.apellido;
      _nombreController.text = widget.userToEdit!.nombre;
      _correoController.text = widget.userToEdit!.correo;
      _passwordController.text = widget.userToEdit!.contrasenia;
      _estadoSeleccionado = widget.userToEdit!.estado;
      _rolSeleccionado = widget.userToEdit!.rol;
    }
  }

  Future<void> _submitForm() async {
    if (_apellidoController.text.isEmpty ||
        _nombreController.text.isEmpty ||
        _correoController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      return;
    }

    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    final nuevoUsuario = User(
      id: widget.userToEdit?.id ?? '',
      apellido: _apellidoController.text,
      nombre: _nombreController.text,
      estado: _estadoSeleccionado,
      fechaUltimoAcceso: widget.userToEdit?.fechaUltimoAcceso ?? DateTime.now(),
      rol: _rolSeleccionado,
      contrasenia: _passwordController.text,
      correo: _correoController.text,
      informeReciente: '', // Asignamos un valor predeterminado vacío o algo que consideres adecuado
      tareas: [], // Lista vacía de tareas, puedes agregar lógica más adelante para completarlo
    );

    try {
      await widget.onSubmit(nuevoUsuario);
      Navigator.of(context).pop();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el usuario: $error')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userToEdit == null ? 'Agregar Nuevo Usuario' : 'Editar Usuario'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
            TextField(
              controller: _correoController,
              decoration: InputDecoration(
                labelText: 'Correo Electrónico',
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
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
                DropdownMenuItem(value: 'Agente Sanitario', child: Text('Agente Sanitario')),
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
              onPressed: _isSubmitting ? null : _submitForm,
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
      ),
    );
  }
}