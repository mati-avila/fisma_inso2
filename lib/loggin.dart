import 'dart:convert';
import 'package:flutter/material.dart';
import 'models/user.dart';
import 'agente sanitario/agent_screen.dart'; // Asegúrate de importar la pantalla del agente sanitario
import 'admin/user_list.dart'; // Asegúrate de importar la pantalla del administrador
import 'supervisor/supervisor_screen.dart'; // Asegúrate de importar la pantalla del supervisor
import 'admin/local_storage.dart'; // Asegúrate de importar tu archivo de almacenamiento local

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true; // Estado para manejar la visibilidad de la contraseña

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              // Imagen de fondo
              // image: DecorationImage(
              //   image: AssetImage('assets/fondos.jpg'), 
              //   fit: BoxFit.cover,
              // ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.blue.withOpacity(1),
                  const Color.fromARGB(255, 197, 226, 250).withOpacity(0.4),
                ],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/logo_fisma_sf.png',
                        height: 200,
                      ),
                      const SizedBox(height: 40),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 350),
                        child: Column(
                          children: [
                            TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.9),
                                hintText: 'Correo electrónico',
                                prefixIcon: const Icon(Icons.email),
                                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscurePassword, // Usa el estado para mostrar u ocultar la contraseña
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.9),
                                hintText: 'Contraseña',
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 108, 169, 255),
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: _login,
                        child: const Text('Iniciar Sesión', style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        child: const Text(
                          '¿Olvidaste tu contraseña?',
                          style: TextStyle(color: Colors.black87),
                        ),
                        onPressed: () {
                          // Aquí iría la lógica para recuperar la contraseña
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _login() async {
  final String email = _emailController.text;
  final String password = _passwordController.text;

  // Verificación de credenciales de administrador
  if (email == 'admin' && password == 'admin') {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => UserListScreen()), // Pantalla del administrador
    );
  } else {
    // Cargar la lista de usuarios desde almacenamiento local
    final List<User> users = getAllUsersFromLocalStorage();

    try {
      // Buscar si existe un usuario con las credenciales ingresadas
      final User user = users.firstWhere(
        (u) => u.correo == email && u.contrasenia == password,
        orElse: () => throw Exception('Usuario no encontrado'), // Lanzar una excepción si no se encuentra
      );

      // Navegar según el rol del usuario
      if (user.rol == 'Agente Sanitario') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AgentScreen()), // Pantalla del agente sanitario
        );
      } else if (user.rol == 'Supervisor') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SupervisorDashboard()), // Pantalla del supervisor
        );
      }
    } catch (e) {
      // Mostrar un mensaje de error si las credenciales no son correctas
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Correo o contraseña incorrectos'),
          actions: [
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }
}



}
