//Esta es la lista filtrada de familias ausentes.

import 'package:flutter/material.dart';

class FilteredList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
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
