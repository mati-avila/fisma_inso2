import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'validaciones.dart'; // Para las validaciones
import 'checkbox_manager.dart'; // Para los métodos relacionados con Checkbox
import 'pdf_manager.dart'; // Para la generación de PDF
import 'data_manager.dart'; // Para manejar los datos generales y listas

class PaginaCrearFormulario extends StatefulWidget {
  const PaginaCrearFormulario({super.key});

  @override
  _PaginaCrearFormulario createState() => _PaginaCrearFormulario();
}

class _PaginaCrearFormulario extends State<PaginaCrearFormulario> {
  final _formKey = GlobalKey<FormState>();
  //final TextEditingController _controller = TextEditingController();

  // Instancias de clases que manejan lógica
  final DataManager dataManager = DataManager();
  final CheckboxManager checkboxManager = CheckboxManager();
  //final PdfManager pdfManager = PdfManager();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario 833'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ..._buildFormFields(),
                SizedBox(height: 16.0),
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
        decoration: InputDecoration(
            labelText: 'Ingrese ID de Visita', border: OutlineInputBorder()),
        validator: Validaciones.validarNumerico,
        onSaved: (value) => _idVisita = value!,
      ),
      SizedBox(height: 16.0),
      TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
            labelText: 'Ingrese ID de Familia', border: OutlineInputBorder()),
        validator: Validaciones.validarNumerico,
        onSaved: (value) => _idFamilia = value!,
      ),
      SizedBox(height: 16.0),
      TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
            labelText: 'Ingrese Numero de Sector',
            border: OutlineInputBorder()),
        validator: Validaciones.validarNumerico,
        onSaved: (value) => _numSector = value!,
      ),
      SizedBox(height: 16.0),
      TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
            labelText: 'Ingrese Numero de Casa', border: OutlineInputBorder()),
        validator: Validaciones.validarNumerico,
        onSaved: (value) => _numCasa = value!,
      ),
      SizedBox(height: 16.0),
      TextFormField(
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.allow(
              RegExp(r'[a-zA-Z\s]')), // Permite solo letras y espacios
        ],
        decoration: InputDecoration(
            labelText: 'Nombre del Titular', border: OutlineInputBorder()),
        validator: Validaciones.validarVacio,
        onSaved: (value) => _nomTitular = value!,
      ),
      SizedBox(height: 16.0),
      TextFormField(
        decoration: InputDecoration(
            labelText: 'Dirección', border: OutlineInputBorder()),
        validator: Validaciones.validarVacio,
        onSaved: (value) => _direccion = value!,
      ),
      SizedBox(height: 16.0),
      TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
            labelText: 'Ingrese Numero de celular sin el 15',
            border: OutlineInputBorder()),
        validator: Validaciones.validarCelular,
        onSaved: (value) => _numTelefono = value!,
      ),
      SizedBox(height: 16.0),
      TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText:
                'Ingrese (Latitud , Longitud) separados por una coma (,)',
            border: OutlineInputBorder()),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[-+0-9.,]')),
        ],
        validator: Validaciones.validarCoordenadas,
        onSaved: (value) => _coordinates = value!,
      ),

      //LISTAS
      SizedBox(height: 16.0),
      DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: 'Seleccione Tipo de Casa'),
        items: dataManager.tiposDeCasas.map((String tipo) {
          return DropdownMenuItem<String>(
            value: tipo,
            child: Text(tipo),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selecTipoCasa = newValue;
          });
        },
        value: _selecTipoCasa,
        validator: (value) {
          if (value == null) {
            return 'Por favor, seleccione un tipo de Casa.';
          }
          return null;
        },
      ),
      SizedBox(height: 16.0),
      DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: 'Seleccione Tipo de Familia'),
        items: dataManager.tiposDeFamilia.map((String tipo) {
          return DropdownMenuItem<String>(
            value: tipo,
            child: Text(tipo),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedTipoFamilia = newValue;
          });
        },
        value: _selectedTipoFamilia,
        validator: (value) {
          if (value == null) {
            return 'Por favor, seleccione un tipo de Familia.';
          }
          return null;
        },
      ),
      SizedBox(height: 16.0),
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...entry.value.map((item) {
              return CheckboxListTile(
                title: Text(item),
                value: checkboxManager.seleccionadosPorCategoria[entry.key]!
                    .contains(item),
                onChanged: (isSelected) {
                  setState(() {
                    checkboxManager.onCheckboxChanged(
                        entry.key, item, isSelected!);
                  });
                },
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
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              setState(() {
                checkboxManager.generarResultados();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Formulario correcto.'),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Por favor, revise los campos ingresados.'),
                ),
              );
            }
          },
          child: Text('Guardar Formulario'),
        ),
        SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              setState(() {
                checkboxManager.generarResultados();
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Formulario ingresa correctamente.')),
              );

              // Llamar a la nueva funcionalidad de PdfManager
              await PdfManager().generateAndSavePdf(
                  _idVisita,
                  _idFamilia,
                  _numSector,
                  _numCasa,
                  _nomTitular,
                  _direccion,
                  _numTelefono,
                  _selecTipoCasa,
                  _selectedTipoFamilia,
                  _coordinates,
                  checkboxManager.resultados);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Por favor, revise los campos ingresados.')),
              );
            }
          },
          child: Text('Imprimir'),
        ),
      ],
    );
  }

  bool _validateForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return true;
    }
    return false;
  }
}
