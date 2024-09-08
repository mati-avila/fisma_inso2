//Aquí estarán los botones para crear, modificar y eliminar formularios.

import 'package:flutter/material.dart';

class FormButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {},
          child: Text('Crear formulario'),
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text('Modificar formulario'),
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text('Eliminar formulario'),
        ),
      ],
    );
  }
}
