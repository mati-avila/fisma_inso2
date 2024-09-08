import 'package:flutter/material.dart';
import 'agente sanitario/agent_screen.dart'; // Asegúrate de importar el archivo donde definiste HomeScreen

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue[100]!, const Color.fromARGB(255, 197, 226, 250)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const FlutterLogo(size: 100),
                  const SizedBox(height: 50),
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Correo electrónico',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 168, 209, 250),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      // Navegar a la página de inicio
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => AgentScreen()),
                      );
                    },
                    child: Text('Iniciar Sesión', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    child: const Text('¿Olvidaste tu contraseña?', style: TextStyle(color: Color.fromARGB(255, 17, 0, 0))),
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
    );
  }
}