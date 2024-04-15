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

                // Nombre del producto
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del producto',
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'El nombre del producto es obligatorio';
                    }
                    return null;
                  },
                ),

                // Descripcion del producto
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: descripcion,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Descripcion',
                    prefixIcon: Icon(Icons.text_snippet_outlined),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'La descripción del producto es obligatoria';
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
                    prefixIcon: Icon(Icons.currency_exchange),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'El precio es obligatorio';
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
