import 'package:flutter/material.dart';
import 'package:fisma_inso2/models/user.dart';
import 'user_form.dart';

class UserDetailsScreen extends StatefulWidget {
  final User user;
  final Function(User) onUpdate;
  final Function(String) onDelete;
  final List<User> existingUsers; // Lista de usuarios existentes

  UserDetailsScreen({
    required this.user,
    required this.onUpdate,
    required this.onDelete,
    required this.existingUsers, // Recibe la lista de usuarios existentes
  });

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  bool _showPassword = false;

  void _editUser(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => UserFormScreen(
          onSubmit: (updatedUser) {
            // Verificar si el correo ya está registrado
            final correoExistente = widget.existingUsers.any((user) =>
                user.correo == updatedUser.correo && user.id != widget.user.id);
            if (correoExistente) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('El correo electrónico ya está registrado.')),
              );
              return;
            }

            widget.onUpdate(updatedUser); // Actualiza el usuario
            Navigator.of(context).pop(); // Cierra la pantalla de edición
          },
          userToEdit: widget.user,
          existingUsers: widget.existingUsers, // Pasa la lista de usuarios existentes
        ),
      ),
    );
  }

  void _deleteUser(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Eliminar Usuario'),
        content: Text('¿Estás seguro de que quieres eliminar este usuario?'),
        actions: [
          TextButton(
            onPressed: () {
              widget.onDelete(widget.user.id); // Elimina el usuario
              Navigator.of(context).pop(); // Cierra el diálogo de confirmación
              Navigator.of(context).pop(); // Cierra la pantalla de detalles
            },
            child: Text('Eliminar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Usuario'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Apellido: ${widget.user.apellido}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Nombre: ${widget.user.nombre}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Correo Electrónico: ${widget.user.correo}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Estado: ${widget.user.estado}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Fecha de Último Acceso: ${widget.user.fechaUltimoAcceso.toLocal()}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Rol: ${widget.user.rol}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Contraseña: ${_showPassword ? widget.user.contrasenia : '******'}',
                          style: TextStyle(fontSize: 18),
                        ),
                        IconButton(
                          icon: Icon(
                            _showPassword ? Icons.visibility : Icons.visibility_off,
                            color: Colors.teal,
                          ),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _editUser(context),
                  child: Text('Editar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _deleteUser(context),
                  child: Text('Eliminar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
