// lib/screens/user_list.dart
import 'package:flutter/material.dart';
import 'package:fisma_inso2/models/user.dart';
import 'local_storage.dart'; // Asegúrate de importar el archivo de almacenamiento
import 'user_form.dart'; // Asegúrate de que el nombre del archivo esté correcto
import 'user_details.dart'; // Asegúrate de que el nombre del archivo esté correcto
import 'package:fisma_inso2/loggin.dart'; // Asegúrate de tener una pantalla de login para redirigir después de cerrar sesión

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<User> _users = [];
  List<User> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    setState(() {
      _users = getAllUsersFromLocalStorage();
      _filteredUsers = _users; // Inicializa la lista filtrada
    });
  }

  void _addUser(User user) {
    setState(() {
      _users.add(user);
      _filteredUsers = _users; // Actualiza la lista filtrada
    });
    saveUserToLocalStorage(user); // Guarda en el almacenamiento local
  }

  void _updateUser(User updatedUser) {
    setState(() {
      _users = _users.map((user) {
        return user.id == updatedUser.id ? updatedUser : user;
      }).toList();
      _filteredUsers = _users; // Actualiza la lista filtrada
    });
    saveUserToLocalStorage(updatedUser); // Guarda en el almacenamiento local
  }

  void _deleteUser(String userId) {
    setState(() {
      _users.removeWhere((user) => user.id == userId);
      _filteredUsers = _users; // Actualiza la lista filtrada
    });
    deleteUserFromLocalStorage(userId); // Elimina del almacenamiento local
  }

  void _showUserForm(BuildContext context, {User? userToEdit}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 10,
          backgroundColor: Colors.white,
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: UserFormScreen(
              onSubmit: userToEdit == null ? _addUser : _updateUser,
              userToEdit: userToEdit,
            ),
          ),
        );
      },
    );
  }

  void _viewUserDetails(User user) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => UserDetailsScreen(
          user: user,
          onUpdate: _updateUser,
          onDelete: _deleteUser,
        ),
      ),
    );
  }

  void _filterUsers(String query) {
    setState(() {
      _filteredUsers = _users.where((user) {
        final fullName = '${user.apellido} ${user.nombre}'.toLowerCase();
        final searchLower = query.toLowerCase();
        return fullName.contains(searchLower);
      }).toList();
    });
  }

  void _logout() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => LoginScreen(), // Redirige a la pantalla de login
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panel de Administrador'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Cerrar Sesión',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Buscar usuarios...',
                prefixIcon: Icon(Icons.search, color: Colors.blue[800]),
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: _filterUsers,
            ),
          ),
          Expanded(
            child: _filteredUsers.isEmpty
                ? Center(
                    child: Text(
                      'No se encontraron usuarios.',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredUsers.length,
                    itemBuilder: (ctx, index) {
                      final user = _filteredUsers[index];
                      return Card(
                        color: Colors.grey[100],
                        margin: EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            '${user.apellido}, ${user.nombre}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Estado: ${user.estado} | Último acceso: ${user.fechaUltimoAcceso.toLocal()} | Rol: ${user.rol}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          leading: Icon(
                            Icons.person,
                            color: Colors.blue[800],
                          ),
                          onTap: () => _viewUserDetails(user),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showUserForm(context); // Muestra el formulario para agregar usuario
        },
        child: Icon(Icons.add),
        tooltip: 'Agregar Usuario',
      ),
    );
  }
}
