import 'package:flutter/material.dart';

class FormButtons extends StatelessWidget {
  const FormButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {},
          child: const Text('Crear formulario'),
        ),
        const SizedBox(height: 16), // Espacio de 16 píxeles entre los botones
        ElevatedButton(
          onPressed: () {},
          child: const Text('Modificar formulario'),
        ),
        const SizedBox(height: 16), // Otro espacio de 16 píxeles entre los botones
        ElevatedButton(
          onPressed: () {},
          child: const Text('Eliminar formulario'),
        ),
      ],
    );
  }
}
