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
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Buscar',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 200,
          child: TextField(
            controller: nombreController,
            decoration: const InputDecoration(
              hintText: 'Nombre',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(8.0),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 200,
          child: TextField(
            controller: apellidoController,
            decoration: const InputDecoration(
              hintText: 'Apellido',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(8.0),
            ),
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
