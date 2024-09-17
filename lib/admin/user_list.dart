import 'package:fisma_inso2/loggin.dart';
import 'package:flutter/material.dart';
import 'package:fisma_inso2/models/user.dart' as models_user;
import 'user_form.dart';
import 'user_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<models_user.User> _users = [];
  List<models_user.User> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _loadUsersFromStorage();
  }

  void _loadUsersFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usersJson = prefs.getString('users');
    if (usersJson != null) {
      setState(() {
        _users = models_user.User.decode(usersJson);
        _filteredUsers = _users;
      });
    }
  }

  void _saveUsersToStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('users', models_user.User.encode(_users));
  }

  void _addUser(models_user.User user) {
    setState(() {
      _users.add(user);
      _filteredUsers = _users;
    });
    _saveUsersToStorage();
  }

  void _updateUser(models_user.User updatedUser) {
    setState(() {
      _users = _users.map((user) {
        return user.id == updatedUser.id ? updatedUser : user;
      }).toList();
      _filteredUsers = _users;
    });
    _saveUsersToStorage();
  }

  void _deleteUser(String userId) {
    setState(() {
      _users.removeWhere((user) => user.id == userId);
      _filteredUsers = _users;
    });
    _saveUsersToStorage();
  }

  void _filterUsers(String query) {
    setState(() {
      _filteredUsers = _users.where((user) {
        final fullName = '${user.apellido} ${user.nombre}'.toLowerCase();
        return fullName.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administrador'),
        centerTitle: true,
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
                ? const Center(child: Text('No se encontraron usuarios.'))
                : ListView.builder(
                    itemCount: _filteredUsers.length,
                    itemBuilder: (ctx, index) {
                      final user = _filteredUsers[index];
                      return Card(
                        child: ListTile(
                          title: Text('${user.apellido}, ${user.nombre}'),
                          subtitle: Text('Rol: ${user.rol}'),
                          onTap: () => _viewUserDetails(user),
                        ),
                      );
                    },
                  ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text('Cerrar sesion'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showUserForm(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showUserForm(BuildContext context, {models_user.User? userToEdit}) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: UserFormScreen(
          onSubmit: userToEdit == null ? _addUser : _updateUser,
          userToEdit: userToEdit,
        ),
      ),
    );
  }

  void _viewUserDetails(models_user.User user) {
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
}
