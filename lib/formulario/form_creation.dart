import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'validaciones.dart'; // Para las validaciones
import 'checkbox_manager.dart'; // Para los métodos relacionados con Checkbox
import 'data_manager.dart'; // Para manejar los datos generales y listas
import 'form_data.dart'; // Importar el archivo donde se guardan los formularios

class PaginaCrearFormulario extends StatefulWidget {
  final Formulario? formulario; // Formulario existente si es modificación
  final bool isModifying; // Para saber si estamos modificando

  const PaginaCrearFormulario({
    super.key,
    this.formulario,
    required this.isModifying,
  });

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
  void initState() {
    super.initState();
    if (widget.isModifying && widget.formulario != null) {
      // Cargar los datos del formulario existente
      _idVisita = widget.formulario!.idVisita;
      _idFamilia = widget.formulario!.idFamilia;
      _numSector = widget.formulario!.numSector;
      _numCasa = widget.formulario!.numCasa;
      _nomTitular = widget.formulario!.nomTitular;
      _direccion = widget.formulario!.direccion;
      _numTelefono = widget.formulario!.numTelefono;
      _selecTipoCasa = widget.formulario!.tipoCasa;
      _selectedTipoFamilia = widget.formulario!.tipoFamilia;
      _coordinates = widget.formulario!.coordinates;

      // Cargar resultados previos en el CheckboxManager
      checkboxManager.resultados = widget.formulario!.resultados;

      // Iterar sobre todas las categorías disponibles en CheckboxManager
      checkboxManager.categorias.forEach((categoria, opciones) {
        // Cargar las opciones seleccionadas previas
        checkboxManager.seleccionadosPorCategoria[categoria] =
            (checkboxManager.resultados[categoria] is String &&
                    checkboxManager.resultados[categoria]!.isNotEmpty)
                ? checkboxManager.resultados[categoria]!.split(', ').toList()
                : [];
      });

      print(
          'Datos cargados de los checkboxes: ${checkboxManager.seleccionadosPorCategoria}');
    }
  }

  void _guardarFormulario() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Generar resultados basados en las selecciones actuales
      checkboxManager.generarResultados();

      // Crear una instancia del formulario
      Formulario nuevoFormulario = Formulario(
        idVisita: widget.isModifying ? widget.formulario!.idVisita : _idVisita,
        idFamilia: _idFamilia,
        numSector: _numSector,
        numCasa: _numCasa,
        nomTitular: _nomTitular,
        direccion: _direccion,
        numTelefono: _numTelefono,
        tipoCasa: _selecTipoCasa,
        tipoFamilia: _selectedTipoFamilia,
        coordinates: _coordinates,
        resultados: checkboxManager.resultados,
      );

      // Evitar agregar duplicados si es una nueva creación
      if (!widget.isModifying) {
        // Verificar si el campo ID de Visita no está vacío
        if (_idVisita.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('El ID de Visita no puede estar vacío.')),
          );
          return; // Detener la ejecución si el campo está vacío
        }

        // Verificar si el formulario ya existe en la lista por su ID
        int index = formularios
            .indexWhere((f) => f.idVisita == nuevoFormulario.idVisita);

        if (index != -1) {
          // Mostrar un mensaje si el formulario ya existe
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Formulario con ese ID Visita ya existe.')),
          );
          return; // Detener la ejecución si el formulario ya existe
        }
      }

      // Si estamos modificando, actualizamos el formulario existente
      if (widget.isModifying) {
        int index = formularios
            .indexWhere((f) => f.idVisita == nuevoFormulario.idVisita);
        if (index != -1) {
          formularios[index] =
              nuevoFormulario; // Actualiza el formulario en la lista
        }
      }

      // Mostrar el mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.isModifying
              ? 'Formulario modificado correctamente.'
              : 'Formulario guardado correctamente.'),
        ),
      );

      // Regresar a la pantalla anterior
      Navigator.pop(context, nuevoFormulario);
    }
  }

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
            labelText: 'Ingrese ID de Visita', border: OutlineInputBorder()),
        validator: widget.isModifying ? null : Validaciones.validarNumerico,

        onSaved: (value) => _idVisita = value!,
        initialValue:
            _idVisita, // Mostrar el valor actual si estamos modificando
        enabled:
            !widget.isModifying, // Deshabilitar el campo si estamos modificando
      ),
      const SizedBox(height: 16.0),
      TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
            labelText: 'Ingrese ID de Familia', border: OutlineInputBorder()),
        validator: Validaciones.validarNumerico,
        onSaved: (value) => _idFamilia = value!,
        initialValue:
            _idFamilia, // Establece el valor inicial si es modificación
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
        initialValue:
            _numSector, // Establece el valor inicial si es modificación
      ),
      const SizedBox(height: 16.0),
      TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
            labelText: 'Ingrese Numero de Casa', border: OutlineInputBorder()),
        validator: Validaciones.validarNumerico,
        onSaved: (value) => _numCasa = value!,
        initialValue: _numCasa, // Establece el valor inicial si es modificación
      ),
      const SizedBox(height: 16.0),
      TextFormField(
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(
                r'[a-zA-ZáéíóúÁÉÍÓÚ\s]'), // Permite letras, espacios y caracteres acentuados
          ),
        ],
        decoration: const InputDecoration(
            labelText: 'Nombre del Titular', border: OutlineInputBorder()),
        validator: Validaciones.validarVacio,
        onSaved: (value) => _nomTitular = value!,
        initialValue:
            _nomTitular, // Establece el valor inicial si es modificación
      ),
      const SizedBox(height: 16.0),
      TextFormField(
        decoration: const InputDecoration(
            labelText: 'Dirección', border: OutlineInputBorder()),
        validator: Validaciones.validarVacio,
        onSaved: (value) => _direccion = value!,
        initialValue:
            _direccion, // Establece el valor inicial si es modificación
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
        initialValue:
            _numTelefono, // Establece el valor inicial si es modificación
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
        initialValue: _coordinates,
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
        onChanged: (String? newValue) {
          setState(() {
            _selecTipoCasa = newValue; // Actualiza el valor seleccionado
          });
        },
        value: _selecTipoCasa, // Muestra el valor seleccionado actual
        validator: (value) {
          if (value == null) {
            return 'Por favor, seleccione un tipo de Casa.';
          }
          return null;
        },
      ),
      const SizedBox(height: 16.0),
      DropdownButtonFormField<String>(
        decoration: const InputDecoration(labelText: 'Seleccione Tipo de Familia'),
        items: dataManager.tiposDeFamilia.map((String tipo) {
          return DropdownMenuItem<String>(
            value: tipo,
            child: Text(tipo),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedTipoFamilia = newValue; // Actualiza el valor seleccionado
          });
        },
        value: _selectedTipoFamilia, // Muestra el valor seleccionado actual
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
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
            }),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        if (!widget
            .isModifying) // Solo muestra este botón si no es modificación
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _guardarFormulario();
              }
            },
            child: const Text('Guardar Formulario'),
          ),
        if (widget.isModifying) // Solo muestra este botón si es modificación
          ElevatedButton(
            onPressed: _guardarFormulario,
            child: const Text('Guardar Cambios'),
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
