import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.grey[200], // Establece el color de fondo a gris claro
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0, vertical: 8.0), // Ajuste el padding
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Espacio entre los elementos
          children: [
            // Contenedor para los elementos de navegación
            Row(
              children: [
                // Página web
                Row(
                  children: [
                    const Icon(Icons.language,
                        color: Colors.blue, size: 18), // Ícono pequeño
                    const SizedBox(width: 4), // Espaciado reducido
                    InkWell(
                      onTap: () {
                        // Acción para la página web
                        print('Ir a la página web');
                      },
                      child: const Text(
                        'Página web',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue), // Tamaño de fuente reducido
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16), // Espaciado entre los elementos
                // Acerca de
                Row(
                  children: [
                    const Icon(Icons.info,
                        color: Colors.blue, size: 18), // Ícono pequeño
                    const SizedBox(width: 4), // Espaciado reducido
                    InkWell(
                      onTap: () {
                        // Acción para Acerca de
                        print('Acerca de');
                      },
                      child: const Text(
                        'Acerca de',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue), // Tamaño de fuente reducido
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16), // Espaciado entre los elementos
                // Soporte
                Row(
                  children: [
                    const Icon(Icons.support_agent,
                        color: Colors.blue, size: 18), // Ícono pequeño
                    const SizedBox(width: 4), // Espaciado reducido
                    InkWell(
                      onTap: () {
                        // Acción para Soporte
                        print('Soporte');
                      },
                      child: const Text(
                        'Soporte',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue), // Tamaño de fuente reducido
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Texto de copyright alineado a la derecha
            const Text(
              '© 2024 SISFAM. Todos los derechos reservados.',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54), // Tamaño de fuente reducido
            ),
          ],
        ),
      ),
    );
  }
}
