import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fisma_inso2/models/user.dart';
import 'package:fisma_inso2/admin/user_list.dart'; // Asegúrate de importar la pantalla del administrador
import 'package:fisma_inso2/supervisor/supervisor_screen.dart'; // Asegúrate de importar la pantalla del supervisor
import 'package:fisma_inso2/agente sanitario/agent_screen.dart'; // Asegúrate de importar la pantalla del agente sanitario
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true; // Estado para manejar la visibilidad de la contraseña

  // Instancia de Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/jujuy.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color.fromARGB(193, 212, 214, 220),
                  Color.fromARGB(223, 193, 241, 241),
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30), 
                        child: Image.asset(
                          'assets/logo.png',
                          height: 250,
                        ),
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
                                fillColor: const Color.fromARGB(200, 255, 255, 255).withOpacity(0.9),
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
                              obscureText: _obscurePassword, 
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color.fromARGB(200, 255, 255, 255).withOpacity(0.9),
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
                          backgroundColor: const Color.fromARGB(220, 156, 172, 170),
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: _login,
                        child: const Text('Iniciar sesión', style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 63, 65, 65))),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        child: const Text('¿Olvidaste tu contraseña?', style: TextStyle(color: Colors.black87)),
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

    // Verificación de credenciales de administrador (usuario: admin, contraseña: admin)
    if (email == 'admin' && password == 'admin') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => UserListScreen(), // Pantalla del administrador
        ),
      );
      return;
    }

    try {
      // Consultar Firestore para obtener el usuario con el correo y la contraseña
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('correo', isEqualTo: email)
          .where('contraseña', isEqualTo: password)
          .get();

      if (snapshot.docs.isEmpty) {
        throw Exception('Usuario o contraseña incorrectos');
      }

      final userDoc = snapshot.docs.first;
      final user = User.fromFirestore(userDoc);

      // Guardar datos del usuario en SharedPreferences (opcional)
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', user.id);
      prefs.setString('userRole', user.rol);
      prefs.setString('userEmail', user.correo);
      prefs.setString('userName', user.nombre);
      prefs.setString('userLastName', user.apellido);

      // Navegar según el rol del usuario
      if (user.rol == 'Agente Sanitario') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AgentScreen()), // Pantalla del agente sanitario
        );
      } else if (user.rol == 'Supervisor') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SupervisorDashboard()), // Pantalla del supervisor
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
