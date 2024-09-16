import 'package:flutter/material.dart';

class UserList extends StatelessWidget {
  final String userType;
  final String searchQuery;

  UserList({required this.userType, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    // Simulamos una lista de agentes sanitarios y supervisores (reemplazar con datos reales)
    List<Map<String, String>> users = List.generate(
      20,
      (index) => {
        "id": "ID${index + 1}",
        "nombre": "Nombre $index",
        "apellido": "Apellido $index",
        "estadoDeTareas": index % 2 == 0 ? "Completado" : "Pendiente",
        "fechaUltimoAcceso": "2024-09-${(index % 30) + 1}",
        "rol": index % 2 == 0 ? "Agente Sanitario" : "Supervisor", // Asignamos el rol
      },
    );

    // Filtramos la lista basada en el tipo de usuario y la búsqueda
    List<Map<String, String>> filteredUsers = users
        .where((user) =>
            user["rol"] == userType &&
            (user["nombre"]!.toLowerCase().contains(searchQuery.toLowerCase()) ||
            user["apellido"]!.toLowerCase().contains(searchQuery.toLowerCase()) ||
            user["estadoDeTareas"]!.toLowerCase().contains(searchQuery.toLowerCase()) ||
            user["fechaUltimoAcceso"]!.toLowerCase().contains(searchQuery.toLowerCase())))
        .toList();

    return ListView.builder(
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: filteredUsers[index]["rol"] == "Agente Sanitario"
                  ? Colors.blue // Color para Agentes Sanitarios
                  : Colors.green, // Color para Supervisores
              child: Text(
                filteredUsers[index]["nombre"]![0],
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text('${filteredUsers[index]["id"]}: ${filteredUsers[index]["nombre"]} ${filteredUsers[index]["apellido"]}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rol: ${filteredUsers[index]["rol"]}'),
                Text('Último Acceso: ${filteredUsers[index]["fechaUltimoAcceso"]}'),
                Text('Estado de Tareas: ${filteredUsers[index]["estadoDeTareas"]}'),
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
                        String nombre = filteredUsers[index]["nombre"]!;
                        String apellido = filteredUsers[index]["apellido"]!;
                        String estadoDeTareas = filteredUsers[index]["estadoDeTareas"]!;
                        String fechaUltimoAcceso = filteredUsers[index]["fechaUltimoAcceso"]!;
                        String rol = filteredUsers[index]["rol"]!;

                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              title: Text('Editar ${rol}'),
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
                                    // Aquí iría la lógica para guardar los cambios
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
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
                              '¿Está seguro de que desea eliminar a ${filteredUsers[index]["nombre"]} ${filteredUsers[index]["apellido"]}?'),
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
                                // Aquí iría la lógica para eliminar el usuario
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
      },
    );
  }
}
