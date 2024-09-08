//Esta es la lista filtrada de familias ausentes.

import 'package:flutter/material.dart';

class FilteredList extends StatelessWidget {
  const FilteredList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: const [
          ListTile(
            title: Text('Casa 1'),
            trailing: Text('2 min'),
          ),
          ListTile(
            title: Text('Casa 2'),
            trailing: Text('8 min'),
          ),
          // Más elementos de la lista
        ],
      ),
    );
  }
}
