import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'validaciones.dart'; // Para las validaciones
import 'checkbox_manager.dart'; // Para los métodos relacionados con Checkbox
import 'data_manager.dart'; // Para manejar los datos generales y listas

class PaginaBuscarFormulario extends StatefulWidget {
  const PaginaBuscarFormulario({super.key});

  @override
  _PaginaBuscarFormulario createState() => _PaginaBuscarFormulario();
}

class _PaginaBuscarFormulario extends State<PaginaBuscarFormulario> {
  final _formKey = GlobalKey<FormState>();

  // Instancias de clases que manejan lógica
  final DataManager dataManager = DataManager();
  final CheckboxManager checkboxManager = CheckboxManager();

  String _idVisita = '';
  String _idFamilia = '';
  String _numSector = '';
  String _numCasa = '';
  String _nomTitular = '';
  String _direccion = '';
  String _numTelefono = '';
  String? _selecTipoCasa;
  String? _selectedTipoFamilia;
  String _coordinates = '';

  bool _isFormEditable = false; // Controla si los campos están habilitados
  bool _isDeleteButtonEnabled =
      true; // Controla si el botón "Eliminar" está habilitado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario 833'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ..._buildFormFields(),
                const SizedBox(height: 16.0),
                _buildCheckboxSection(),
                _buildButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    return [
      TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          labelText: 'Ingrese ID de Visita',
          border: OutlineInputBorder(),
        ),
        // Este campo sigue inhabilitado y no requiere validación al guardar
        onSaved: (value) => _idVisita = value!,
        enabled: false, // Siempre deshabilitado
      ),
      const SizedBox(height: 16.0),
      TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
            labelText: 'Ingrese ID de Familia', border: OutlineInputBorder()),
        validator: Validaciones.validarNumerico,
        onSaved: (value) => _idFamilia = value!,
        enabled: _isFormEditable, // Controla si está habilitado o no
      ),
      const SizedBox(height: 16.0),
      TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
            labelText: 'Ingrese Numero de Sector',
            border: OutlineInputBorder()),
        validator: Validaciones.validarNumerico,
        onSaved: (value) => _numSector = value!,
        enabled: _isFormEditable,
      ),
      const SizedBox(height: 16.0),
      TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
            labelText: 'Ingrese Numero de Casa', border: OutlineInputBorder()),
        validator: Validaciones.validarNumerico,
        onSaved: (value) => _numCasa = value!,
        enabled: _isFormEditable,
      ),
      const SizedBox(height: 16.0),
      TextFormField(
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.allow(
              RegExp(r'[a-zA-Z\s]')), // Permite solo letras y espacios
        ],
        decoration: const InputDecoration(
            labelText: 'Nombre del Titular', border: OutlineInputBorder()),
        validator: Validaciones.validarVacio,
        onSaved: (value) => _nomTitular = value!,
        enabled: _isFormEditable,
      ),
      const SizedBox(height: 16.0),
      TextFormField(
        decoration: const InputDecoration(
            labelText: 'Dirección', border: OutlineInputBorder()),
        validator: Validaciones.validarVacio,
        onSaved: (value) => _direccion = value!,
        enabled: _isFormEditable,
      ),
      const SizedBox(height: 16.0),
      TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
            labelText: 'Ingrese Numero de celular sin el 15',
            border: OutlineInputBorder()),
        validator: Validaciones.validarCelular,
        onSaved: (value) => _numTelefono = value!,
        enabled: _isFormEditable,
      ),
      const SizedBox(height: 16.0),
      TextFormField(
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
            labelText:
                'Ingrese (Latitud , Longitud) separados por una coma (,)',
            border: OutlineInputBorder()),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[-+0-9.,]')),
        ],
        validator: Validaciones.validarCoordenadas,
        onSaved: (value) => _coordinates = value!,
        enabled: _isFormEditable,
      ),

      //LISTAS
      const SizedBox(height: 16.0),
      DropdownButtonFormField<String>(
        decoration: const InputDecoration(labelText: 'Seleccione Tipo de Casa'),
        items: dataManager.tiposDeCasas.map((String tipo) {
          return DropdownMenuItem<String>(
            value: tipo,
            child: Text(tipo),
          );
        }).toList(),
        onChanged: _isFormEditable
            ? (String? newValue) {
                setState(() {
                  _selecTipoCasa = newValue;
                });
              }
            : null, // Deshabilitado si no es editable
        value: _selecTipoCasa,
        validator: (value) {
          if (value == null) {
            return 'Por favor, seleccione un tipo de Casa.';
          }
          return null;
        },
      ),
      const SizedBox(height: 16.0),
      DropdownButtonFormField<String>(
        decoration:
            const InputDecoration(labelText: 'Seleccione Tipo de Familia'),
        items: dataManager.tiposDeFamilia.map((String tipo) {
          return DropdownMenuItem<String>(
            value: tipo,
            child: Text(tipo),
          );
        }).toList(),
        onChanged: _isFormEditable
            ? (String? newValue) {
                setState(() {
                  _selectedTipoFamilia = newValue;
                });
              }
            : null, // Deshabilitado si no es editable
        value: _selectedTipoFamilia,
        validator: (value) {
          if (value == null) {
            return 'Por favor, seleccione un tipo de Familia.';
          }
          return null;
        },
      ),
      const SizedBox(height: 16.0),
      //FIN LISTAS
    ];
  }

  Widget _buildCheckboxSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: checkboxManager.categorias.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(entry.key,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...entry.value.map((item) {
              return CheckboxListTile(
                title: Text(item),
                value: checkboxManager.seleccionadosPorCategoria[entry.key]!
                    .contains(item),
                onChanged: _isFormEditable
                    ? (isSelected) {
                        setState(() {
                          checkboxManager.onCheckboxChanged(
                              entry.key, item, isSelected!);
                        });
                      }
                    : null, // Deshabilitado si no es editable
              );
            }).toList(),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              _isFormEditable = true; // Habilita los campos
              _isDeleteButtonEnabled =
                  false; // Deshabilita el botón de eliminar
            });
          },
          child: const Text('Modificar Formulario'),
        ),
        const SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: () async {
            // Guardar sin validar el ID de visita
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              setState(() {
                checkboxManager.generarResultados();
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Formulario guardado correctamente.'),
                ),
              );

              // Esperar 1 segundo antes de regresar
              await Future.delayed(const Duration(seconds: 1));
              Navigator.pop(context);
            }
          },
          child: const Text('Guardar Formulario'),
        ),
        const SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: _isDeleteButtonEnabled
              ? () {
                  Navigator.pop(context); // Regresa a la pantalla anterior
                }
              : null, // Deshabilita el botón si es necesario
          child: const Text('Eliminar Formulario'),
        ),
      ],
    );
  }
}
