import 'package:flutter/material.dart';

class FormButtons extends StatelessWidget {
  const FormButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () {
            // Implementar la acción de botón 1
          },
          child: const Text('Botón 1'),
        ),
        ElevatedButton(
          onPressed: () {
            // Implementar la acción de botón 2
          },
          child: const Text('Botón 2'),
        ),
      ],
    );
  }
}
