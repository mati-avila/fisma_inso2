import 'package:flutter/material.dart';
import 'package:fisma_inso2/models/agent_model.dart';
import 'user_dialog.dart';

class UserListItem extends StatelessWidget {
  final Agent agent;
  final VoidCallback onDelete;

  UserListItem({required this.agent, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: agent.rol == "Agente Sanitario"
              ? Colors.blue
              : Colors.green,
          child: Text(
            agent.nombre[0],
            style: TextStyle(color: Colors.white),
          ),
        ),
        title: Text('${agent.id} - ${agent.nombre} ${agent.apellido}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rol: ${agent.rol}'),
            Text('Estado de Tareas: ${agent.estadoDeTareas}'),
            Text('Último Acceso: ${agent.fechaUltimoAcceso}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.grey),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return UserDialog(
                      agent: agent,
                      onSave: (updatedAgent) {
                        // Aquí iría la lógica para actualizar el usuario
                        Navigator.of(context).pop();
                      },
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirmar Eliminación'),
                      content: Text(
                          '¿Está seguro de que desea eliminar a ${agent.nombre} ${agent.apellido}?'),
                      actions: [
                        TextButton(
                          child: Text('Cancelar'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Eliminar'),
                          onPressed: () {
                            onDelete();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
