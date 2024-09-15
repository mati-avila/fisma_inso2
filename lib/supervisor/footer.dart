import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.grey[200], // Establece el color de fondo a gris claro
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Contenedor para los elementos de navegación
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Página web
                      Row(
                        children: [
                          const Icon(Icons.language,
                              color: Colors.blue, size: 18),
                          const SizedBox(width: 4),
                          InkWell(
                            onTap: () {
                              print('Ir a la página web');
                            },
                            child: const Text(
                              'Página web',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      // Acerca de
                      Row(
                        children: [
                          const Icon(Icons.info, color: Colors.blue, size: 18),
                          const SizedBox(width: 4),
                          InkWell(
                            onTap: () {
                              print('Acerca de');
                            },
                            child: const Text(
                              'Acerca de',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      // Soporte
                      Row(
                        children: [
                          const Icon(Icons.support_agent,
                              color: Colors.blue, size: 18),
                          const SizedBox(width: 4),
                          InkWell(
                            onTap: () {
                              print('Soporte');
                            },
                            child: const Text(
                              'Soporte',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Texto de copyright alineado a la derecha
                ConstrainedBox(
                  constraints:
                      BoxConstraints(maxWidth: constraints.maxWidth * 0.5),
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '© 2024 SISFAM. Todos los derechos reservados.',
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
