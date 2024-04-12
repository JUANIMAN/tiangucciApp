import 'package:flutter/material.dart';
import 'package:tiangucci/vistas/registro_usuario.dart';

class EditarArticulo extends StatefulWidget {
  final String titulo;
  final double precio;
  final String categoria;
  final String descripcion;
  final String foto;
  const EditarArticulo(this.titulo, this.precio, this.categoria,
      this.descripcion, this.foto,
      {super.key, required this.title});

  final String title;

  @override
  State<EditarArticulo> createState() => _EditarArticulo();
}

class _EditarArticulo extends State<EditarArticulo> {
  @override
  Widget build(BuildContext context) {
    String selectedOption = widget.categoria; // Opcion por default

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(widget.titulo),
            Text(widget.precio.toString()),
            DropdownButton<String>(
              hint: const Text('Selecciona una opción'), // Texto de ayuda
              value: selectedOption, // Valor seleccionado (opcional)
              onChanged: (newValue) {
                setState(() {
                  // Actualiza el valor seleccionado
                  selectedOption = newValue!;
                });
              },
              items: <String>[
                'comida',
                'ropa',
                'joyeria',
                'peluches',
              ].map<DropdownMenuItem<String>>((String value) {
                // Mapea cada opción a un DropdownMenuItem
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value), // Texto de la opción
                );
              }).toList(),
            ),
            Text(widget.descripcion),
            Text(widget.foto),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterPage()));
              },
              child: const Text('SUBIR'),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
