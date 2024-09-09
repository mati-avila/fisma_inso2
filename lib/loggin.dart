import 'package:flutter/material.dart';
import 'agente sanitario/agent_screen.dart'; // Asegúrate de importar el archivo donde definiste HomeScreen

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Imagen de fondo
          Container(
            decoration: const BoxDecoration(
              //image: DecorationImage(
                //image: AssetImage('assets/fondos.jpg'), // Ruta de la imagen de fondo
                //fit: BoxFit.cover,
              //),
            ),
          ),
          // El contenido sobre la imagen de fondo
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.blue.withOpacity(1), // Más opacidad para mejor visibilidad
                  const Color.fromARGB(255, 197, 226, 250).withOpacity(0.4),
                ],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0), // Más espacio a los lados
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Imagen personalizada en lugar del logo de Flutter
                      Image.asset(
                        'assets/logo_fisma_sf.png', // Ruta de la imagen personalizada
                        height: 200, // Ajusta el tamaño de la imagen según necesites
                      ),
                      const SizedBox(height: 40),
                      // Centrar los campos y reducir su tamaño
                      ConstrainedBox(
                        constraints: BoxConstraints(
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
                                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25), // Bordes más redondeados
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
                                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25), // Bordes más redondeados
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
                          backgroundColor: const Color.fromARGB(255, 108, 169, 255),
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25), // Bordes suaves
                          ),
                        ),
                        onPressed: () {
                          // Navegar a la página de inicio
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => AgentScreen()),
                          );
                        },
                        child: const Text('Iniciar Sesión', style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                      const SizedBox(height: 20),
                      // Texto de olvido de contraseña con estilo
                      TextButton(
                        child: const Text(
                          '¿Olvidaste tu contraseña?',
                          style: TextStyle(
                            color: Colors.black87, // Texto más oscuro para mejor legibilidad
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
