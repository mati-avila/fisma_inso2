import 'package:flutter/material.dart';

class SearchForm extends StatelessWidget {
  final TextEditingController nombreController;
  final TextEditingController apellidoController;
  final VoidCallback onSearch;

  const SearchForm({
    super.key,
    required this.nombreController,
    required this.apellidoController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Buscar',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold), // Ajuste del tamaño del texto
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 4,
          child: TextField(
            controller: nombreController,
            decoration: const InputDecoration(
              hintText: 'Nombre',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                  vertical: 8.0, horizontal: 10.0), // Ajuste del padding
              hintStyle: TextStyle(
                  fontSize: 14), // Ajuste del tamaño del texto del hint
            ),
            style: const TextStyle(
                fontSize: 14), // Ajuste del tamaño del texto de entrada
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 4,
          child: TextField(
            controller: apellidoController,
            decoration: const InputDecoration(
              hintText: 'Apellido',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                  vertical: 8.0, horizontal: 10.0), // Ajuste del padding
              hintStyle: TextStyle(
                  fontSize: 14), // Ajuste del tamaño del texto del hint
            ),
            style: const TextStyle(
                fontSize: 14), // Ajuste del tamaño del texto de entrada
          ),
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: onSearch,
        ),
      ],
    );
  }
}
