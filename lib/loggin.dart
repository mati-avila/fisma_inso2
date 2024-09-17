import 'package:fisma_inso2/agente%20sanitario/agent_screen.dart';
import 'package:fisma_inso2/supervisor/supervisor_screen.dart';
import 'package:flutter/material.dart';
import 'package:fisma_inso2/admin/user_list.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _selectedRole = 'Supervisor'; // Valor por defecto

  void _handleLogin() {
    // Aquí deberías agregar la lógica para la autenticación de usuario
    // y determinar la pantalla a la que navegar basada en el rol seleccionado
    switch (_selectedRole) {
      case 'Agente Sanitario':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AgentScreen()),
        );
        break;
      case 'Supervisor':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SupervisorDashboard()),
        );
        break;
      case 'Administrador':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const UserListScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Imagen de fondo
          Container(
            decoration: const BoxDecoration(
                // Aquí puedes añadir la imagen de fondo si lo deseas
                ),
          ),
          // El contenido sobre la imagen de fondo
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.blue
                      .withOpacity(1), // Más opacidad para mejor visibilidad
                  const Color.fromARGB(255, 197, 226, 250).withOpacity(0.4),
                ],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0), // Más espacio a los lados
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Imagen personalizada en lugar del logo de Flutter
                      Image.asset(
                        'assets/logo_fisma_sf.png', // Ruta de la imagen personalizada
                        height:
                            200, // Ajusta el tamaño de la imagen según necesites
                      ),
                      const SizedBox(height: 40),
                      // Centrar los campos y reducir su tamaño
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 350, // Reducir el ancho de los campos
                        ),
                        child: Column(
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.9),
                                hintText: 'Correo electrónico',
                                prefixIcon: const Icon(Icons.email),
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      25), // Bordes más redondeados
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.9),
                                hintText: 'Contraseña',
                                prefixIcon: const Icon(Icons.lock),
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      25), // Bordes más redondeados
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            DropdownButtonFormField<String>(
                              value: _selectedRole,
                              items: const [
                                DropdownMenuItem(
                                    value: 'Agente Sanitario',
                                    child: Text('Agente Sanitario')),
                                DropdownMenuItem(
                                    value: 'Supervisor',
                                    child: Text('Supervisor')),
                                DropdownMenuItem(
                                    value: 'Administrador',
                                    child: Text('Administrador')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedRole = value!;
                                });
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.9),
                                hintText: 'Selecciona tu rol',
                                prefixIcon: const Icon(Icons.person),
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      25), // Bordes más redondeados
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Botón más estilizado
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 108, 169, 255),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(25), // Bordes suaves
                          ),
                        ),
                        onPressed: _handleLogin,
                        child: const Text('Iniciar Sesión',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                      const SizedBox(height: 20),
                      // Texto de olvido de contraseña con estilo
                      TextButton(
                        child: const Text(
                          '¿Olvidaste tu contraseña?',
                          style: TextStyle(
                            color: Colors
                                .black87, // Texto más oscuro para mejor legibilidad
                          ),
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
}
