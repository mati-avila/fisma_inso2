import 'package:flutter/material.dart';

class ConfigDialog extends StatefulWidget {
  const ConfigDialog({super.key});

  @override
  _ConfigDialogState createState() => _ConfigDialogState();
}

class _ConfigDialogState extends State<ConfigDialog> {
  bool isDarkMode = false; // Opción para el tema oscuro
  bool notificationsEnabled = true; // Opción para las notificaciones
  String selectedLanguage = 'Español'; // Idioma por defecto
  String notificationFrequency = 'Diaria'; // Frecuencia de notificaciones
  String textSize = 'Mediano'; // Tamaño de texto por defecto
  bool useMobileData = true; // Uso de datos móviles activado por defecto

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4, // Ajustar el ancho
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Configuración del Sistema',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Opción de tema claro/oscuro
              SwitchListTile(
                title: const Text('Modo Oscuro'),
                value: isDarkMode,
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                  });
                },
              ),
              // Opción de activar/desactivar notificaciones
              SwitchListTile(
                title: const Text('Notificaciones'),
                value: notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    notificationsEnabled = value;
                  });
                },
              ),
              // Selección de la frecuencia de notificaciones
              DropdownButtonFormField<String>(
                value: notificationFrequency,
                items: const [
                  DropdownMenuItem(
                    value: 'Diaria',
                    child: Text('Diaria'),
                  ),
                  DropdownMenuItem(
                    value: 'Semanal',
                    child: Text('Semanal'),
                  ),
                  DropdownMenuItem(
                    value: 'Mensual',
                    child: Text('Mensual'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    notificationFrequency = value!;
                  });
                },
                decoration: const InputDecoration(
                    labelText: 'Frecuencia de Notificaciones'),
              ),
              const SizedBox(height: 20),
              // Tamaño de texto
              DropdownButtonFormField<String>(
                value: textSize,
                items: const [
                  DropdownMenuItem(
                    value: 'Pequeño',
                    child: Text('Pequeño'),
                  ),
                  DropdownMenuItem(
                    value: 'Mediano',
                    child: Text('Mediano'),
                  ),
                  DropdownMenuItem(
                    value: 'Grande',
                    child: Text('Grande'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    textSize = value!;
                  });
                },
                decoration:
                    const InputDecoration(labelText: 'Tamaño del Texto'),
              ),
              const SizedBox(height: 20),
              // Activar/desactivar uso de datos móviles
              SwitchListTile(
                title: const Text('Usar datos móviles'),
                value: useMobileData,
                onChanged: (value) {
                  setState(() {
                    useMobileData = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              // Selección de idioma
              DropdownButtonFormField<String>(
                value: selectedLanguage,
                items: const [
                  DropdownMenuItem(
                    value: 'Español',
                    child: Text('Español'),
                  ),
                  DropdownMenuItem(
                    value: 'Inglés',
                    child: Text('Inglés'),
                  ),
                  DropdownMenuItem(
                    value: 'Francés',
                    child: Text('Francés'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedLanguage = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Idioma'),
              ),
              const SizedBox(height: 20),
              // Botones de acción
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Cierra el diálogo
                    },
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para guardar la configuración
                      Navigator.of(context).pop(); // Cierra el diálogo
                      _saveConfiguration();
                    },
                    child: const Text('Guardar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para simular guardar la configuración
  void _saveConfiguration() {
    print('Configuración guardada:');
    print('Modo Oscuro: $isDarkMode');
    print('Notificaciones: $notificationsEnabled');
    print('Frecuencia de Notificaciones: $notificationFrequency');
    print('Tamaño del Texto: $textSize');
    print('Uso de datos móviles: $useMobileData');
    print('Idioma: $selectedLanguage');
  }
}
