import 'package:flutter/material.dart';

class UserList extends StatelessWidget {
  final String userType;
  final String searchQuery;

  const UserList(
      {super.key, required this.userType, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    // Simulamos una lista de usuarios (reemplazar con datos reales)
    List<Map<String, String>> users = List.generate(
      20,
      (index) => {
        "name": "$userType ${index + 1}",
        "email": "usuario$index@ejemplo.com",
      },
    );

    // Filtramos la lista basada en la búsqueda
    List<Map<String, String>> filteredUsers = users
        .where((user) =>
            user["name"]!.toLowerCase().contains(searchQuery.toLowerCase()) ||
            user["email"]!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.lightBlue,
              child: Text(
                filteredUsers[index]["name"]![0],
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(filteredUsers[index]["name"]!),
            subtitle: Text(filteredUsers[index]["email"]!),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.grey),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        String name = filteredUsers[index]["name"]!;
                        String email = filteredUsers[index]["email"]!;
                        return AlertDialog(
                          title: Text('Editar Usuario'),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  decoration:
                                      InputDecoration(labelText: 'Nombre'),
                                  controller: TextEditingController(text: name),
                                  onChanged: (value) {
                                    name = value;
                                  },
                                ),
                                TextField(
                                  decoration:
                                      InputDecoration(labelText: 'Email'),
                                  controller:
                                      TextEditingController(text: email),
                                  onChanged: (value) {
                                    email = value;
                                  },
                                ),
                                DropdownButtonFormField<String>(
                                  value: userType,
                                  decoration: InputDecoration(
                                      labelText: 'Tipo de Usuario'),
                                  items: <String>[
                                    'Agente Sanitario',
                                    'Supervisor'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    // Aquí se manejaría el cambio de tipo de usuario
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
                              '¿Está seguro de que desea eliminar a ${filteredUsers[index]["name"]}?'),
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
