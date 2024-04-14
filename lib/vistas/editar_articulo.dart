import 'package:flutter/material.dart';
import 'package:tiangucci/vistas/productos.dart';

class EditarArticulo extends StatefulWidget {
  final Product product;
  const EditarArticulo({super.key, required this.product});

  @override
  State<EditarArticulo> createState() => _EditarArticulo();
}

class _EditarArticulo extends State<EditarArticulo> {
  @override
  Widget build(BuildContext context) {
    final descripcion = TextEditingController(text: widget.product.description);
    final price = TextEditingController(text: widget.product.price.toString());
    final nameController = TextEditingController(text: widget.product.name);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Editar producto"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              children: [
                Image.asset(widget.product.image), //Imagen producto

                // Titulo producto
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Titulo',
                    prefixIcon: Icon(Icons.text_fields),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'El titulo es obligatorio';
                    }
                    return null;
                  },
                ),

                // Precio
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: price,
                  decoration: const InputDecoration(
                    labelText: 'Precio',
                    prefixIcon: Icon(Icons.price_check),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'El precio es obligatorio';
                    }
                    return null;
                  },
                ),

                // Correo electrónico
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: descripcion,
                  decoration: const InputDecoration(
                    labelText: 'Descripcion',
                    prefixIcon: Icon(Icons.text_snippet_outlined),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'La descripcion es obligatoria';
                    }
                    return null;
                  },
                ),

                // Botón de actualizacion
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    print(nameController.text);
                  },
                  child: const Text('SUBIR CAMBIOS'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
