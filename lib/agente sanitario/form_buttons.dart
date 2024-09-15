import 'package:flutter/material.dart';

class FormButtons extends StatelessWidget {
  const FormButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Formulario 883',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(
            height: 16), // Espacio de 16 píxeles entre el texto y el botón
        ElevatedButton(
          onPressed: () {},
          child: const Text('Cargar formulario'),
        ),
      ],
    );
  }
}
