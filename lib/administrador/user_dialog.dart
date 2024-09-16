import 'package:flutter/material.dart';
import 'package:fisma_inso2/models/agent_model.dart';

class UserDialog extends StatefulWidget {
  final Agent? agent;
  final void Function(Agent) onSave;

  UserDialog({this.agent, required this.onSave});

  @override
  _UserDialogState createState() => _UserDialogState();
}

class _UserDialogState extends State<UserDialog> {
  late String nombre;
  late String apellido;
  late String estadoDeTareas;
  late String fechaUltimoAcceso;
  late String rol;

  @override
  void initState() {
    super.initState();
    if (widget.agent != null) {
      nombre = widget.agent!.nombre;
      apellido = widget.agent!.apellido;
      estadoDeTareas = widget.agent!.estadoDeTareas;
      fechaUltimoAcceso = widget.agent!.fechaUltimoAcceso;
      rol = widget.agent!.rol;
    } else {
      nombre = '';
      apellido = '';
      estadoDeTareas = 'Completado';
      fechaUltimoAcceso = '2024-09-01';
      rol = 'Agente Sanitario';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.agent != null ? 'Editar ${widget.agent!.rol}' : 'Agregar Nuevo Usuario'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Nombre'),
              controller: TextEditingController(text: nombre),
              onChanged: (value) {
                nombre = value;
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Apellido'),
              controller: TextEditingController(text: apellido),
              onChanged: (value) {
                apellido = value;
              },
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Estado de Tareas'),
              value: estadoDeTareas,
              items: <String>['Completado', 'Pendiente']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  estadoDeTareas = value!;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Último Acceso'),
              controller: TextEditingController(text: fechaUltimoAcceso),
              onChanged: (value) {
                fechaUltimoAcceso = value;
              },
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Rol'),
              value: rol,
              items: <String>['Agente Sanitario', 'Supervisor']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  rol = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Guardar'),
          onPressed: () {
            final newAgent = Agent(
              id: widget.agent?.id ?? 'ID${DateTime.now().millisecondsSinceEpoch}', // Generar ID si es nuevo
              nombre: nombre,
              apellido: apellido,
              estadoDeTareas: estadoDeTareas,
              fechaUltimoAcceso: fechaUltimoAcceso,
              informeReciente: '', // Se puede agregar lógica para informe reciente
              rol: rol,
            );
            widget.onSave(newAgent);
          },
        ),
      ],
    );
  }
}
