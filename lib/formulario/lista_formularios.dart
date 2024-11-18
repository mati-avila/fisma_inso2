import 'package:flutter/material.dart';
import 'form_creation.dart'; // Para acceder a la pantalla de creación/modificación
import 'form_data.dart'; // Para acceder a los formularios guardados
import 'pdf_manager.dart'; // Para imprimir formularios

class ListaFormularios extends StatefulWidget {
  @override
  _ListaFormulariosState createState() => _ListaFormulariosState();
}

class _ListaFormulariosState extends State<ListaFormularios> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formularios Guardados'),
      ),
      body: ListView.builder(
        itemCount: formularios.length,
        itemBuilder: (context, index) {
          final formulario = formularios[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('ID Visita: ${formulario.idVisita}'),
              subtitle: Text(
                  'ID Familia: ${formulario.idFamilia}\nNombre del Titular: ${formulario.nomTitular}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Botón de Ver
                  IconButton(
                    icon: Icon(Icons.visibility),
                    onPressed: () {
                      _verFormulario(formulario);
                    },
                  ),
                  // Botón de Modificar
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      final updatedFormulario = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaginaCrearFormulario(
                            formulario: formulario,
                            isModifying: true,
                          ),
                        ),
                      );

                      if (updatedFormulario != null) {
                        setState(() {
                          formularios[index] =
                              updatedFormulario; // Actualizamos el formulario editado
                        });
                      }
                    },
                  ),
                  // Botón de Eliminar
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        formularios.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Formulario eliminado.')),
                      );
                    },
                  ),
                  // Botón de Imprimir
                  IconButton(
                    icon: Icon(Icons.print),
                    onPressed: () async {
                      await PdfManager().generateAndPrintPdf(
                        formulario.idVisita,
                        formulario.idFamilia,
                        formulario.numSector,
                        formulario.numCasa,
                        formulario.nomTitular,
                        formulario.direccion,
                        formulario.numTelefono,
                        formulario.tipoCasa,
                        formulario.tipoFamilia,
                        formulario.coordinates,
                        formulario.resultados,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      // Botón flotante para agregar un nuevo formulario
      // Método para agregar nuevo formulario
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navegar a la página de creación de formularios
          final newFormulario = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaginaCrearFormulario(isModifying: false),
            ),
          );

          // Verificar si se retorna un formulario nuevo
          if (newFormulario != null) {
            // Verificar si el formulario ya existe en la lista
            final exists = formularios
                .any((form) => form.idVisita == newFormulario.idVisita);

            if (!exists) {
              setState(() {
                formularios.add(newFormulario); // Solo agregar si no existe
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Formulario guardado correctamente.')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Formulario con ese ID ya existe.')),
              );
            }
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Agregar nuevo formulario',
      ),
    );
  }

  void _verFormulario(Formulario formulario) {
    // Abrimos una vista de detalles sin permitir modificación
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detalles del Formulario'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('ID Visita: ${formulario.idVisita}'),
                Text('ID Familia: ${formulario.idFamilia}'),
                Text('Número de Sector: ${formulario.numSector}'),
                Text('Número de Casa: ${formulario.numCasa}'),
                Text('Nombre del Titular: ${formulario.nomTitular}'),
                Text('Dirección: ${formulario.direccion}'),
                Text('Número de Teléfono: ${formulario.numTelefono}'),
                Text(
                    'Tipo de Casa: ${formulario.tipoCasa ?? "No especificado"}'),
                Text(
                    'Tipo de Familia: ${formulario.tipoFamilia ?? "No especificado"}'),
                Text('Coordenadas: ${formulario.coordinates}'),
                Text(
                    'Discapacidad: ${formulario.resultados["Discapacidad"] ?? "N/A"}'),
                Text(
                    'Enfermedades: ${formulario.resultados["Enfermedades"] ?? "N/A"}'),
                Text(
                    'Beneficio Social: ${formulario.resultados["Beneficio Social"] ?? "N/A"}'),
                Text('Vacunas: ${formulario.resultados["Vacunas"] ?? "N/A"}'),
                Text(
                    'Factores de Riesgo: ${formulario.resultados["Factores de Riesgo"] ?? "N/A"}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
