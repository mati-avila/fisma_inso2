import 'package:fisma_inso2/loggin.dart';
import 'package:flutter/material.dart';
import 'package:fisma_inso2/models/user.dart';
import 'user_form.dart';

class UserDetailsScreen extends StatelessWidget {
  final User user;
  final Function(User) onUpdate;
  final Function(String) onDelete;

  const UserDetailsScreen({
    super.key,
    required this.user,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Usuario'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserFormScreen(
                    userToEdit: user,
                    onSubmit: onUpdate,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Eliminar Usuario'),
                  content: const Text(
                      '¿Estás seguro de que deseas eliminar este usuario?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        onDelete(user.id);
                        Navigator.of(context).pop();
                        Navigator.of(context)
                            .pop(); // Regresar a la pantalla anterior después de eliminar
                      },
                      child: const Text('Eliminar'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Solo cerrar el diálogo
                      },
                      child: const Text('Cancelar'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${user.id}',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Nombre: ${user.nombre}',
                style: Theme.of(context).textTheme.bodyLarge),
            Text('Apellido: ${user.apellido}',
                style: Theme.of(context).textTheme.bodyLarge),
            Text('Estado: ${user.estado}',
                style: Theme.of(context).textTheme.bodyLarge),
            Text('Rol: ${user.rol}',
                style: Theme.of(context).textTheme.bodyLarge),
            Text(
                'Último Acceso: ${user.fechaUltimoAcceso.toLocal().toString()}',
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Volver a la pantalla anterior
              },
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}
