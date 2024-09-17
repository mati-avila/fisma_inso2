import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.grey[200], // Color gris claro para el fondo
      child: SizedBox(
        height: 40, // Altura total del footer
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Elementos de navegación
              Row(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.language, color: Colors.blue, size: 14),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: () {
                          print('Ir a la página web');
                        },
                        child: const Text(
                          'Página web',
                          style: TextStyle(fontSize: 13, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Row(
                    children: [
                      const Icon(Icons.info, color: Colors.blue, size: 14),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: () {
                          print('Acerca de');
                        },
                        child: const Text(
                          'Acerca de',
                          style: TextStyle(fontSize: 13, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Row(
                    children: [
                      const Icon(Icons.support_agent,
                          color: Colors.blue, size: 14),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: () {
                          print('Soporte');
                        },
                        child: const Text(
                          'Soporte',
                          style: TextStyle(fontSize: 13, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Texto de copyright
              const Text(
                '© 2024 SISFAM. Todos los derechos reservados.',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
