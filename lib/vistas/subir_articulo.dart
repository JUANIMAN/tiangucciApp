import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SubirProducto extends StatefulWidget {
  const SubirProducto({super.key});

  @override
  State<SubirProducto> createState() => _SubirProductoState();
}

class _SubirProductoState extends State<SubirProducto> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  List<File>? _imageFile;
  final List<String> _categories = ['electronica', 'ropa', 'deporte', 'otros'];
  String? _selectedCategory;

  Future<void> _pickImages() async {
    final pickedImages = await ImagePicker().pickMultiImage();
    setState(() {
      _imageFile = pickedImages.map((image) => File(image.path)).toList();
    });
  }

  Future<void> _uploadProduct() async {
    if (_formKey.currentState!.validate()) {
      // Implement product upload logic here (API call, data storage, etc.)
      // Handle success or error scenarios
      // Show appropriate messages to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Subir Producto'),
      ),
      body: SingleChildScrollView(
        // Allow scrolling if content exceeds screen height
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Product Name TextField
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                      labelText: 'Nombre del producto',
                      prefixIcon: Icon(Icons.title)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El nombre del producto es obligatorio';
                    }
                    return null;
                  },
                ),

                // Product Description TextField
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                      labelText: 'Descripción del producto',
                      prefixIcon: Icon(Icons.text_snippet_outlined)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La descripción del producto es obligatoria';
                    }
                    return null;
                  },
                ),

                // Product Price TextField
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Precio del producto',
                    prefixIcon: Icon(Icons.currency_exchange),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El precio del producto es obligatorio';
                    }
                    try {
                      double.parse(value);
                    } catch (e) {
                      return 'El precio debe ser un número válido';
                    }
                    return null;
                  },
                ),

                // Product Category Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  hint: const Text('Seleccionar categoría'),
                  items: _categories
                      .map((category) => DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Selecciona una categoría';
                    }
                    return null;
                  },
                ),

                TextButton(
                  onPressed: _pickImages,
                  child: const Text('Seleccionar imagenes'),
                ),

                Row(
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        height: 200.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _imageFile?.length ?? 0, // Verifica si _imageFile no es nulo
                          itemBuilder: (BuildContext ctxt, int index) {
                            final imageFile = _imageFile?[index];
                            if (imageFile != null) {
                              return Stack(
                                alignment: Alignment.topRight,
                                children: <Widget>[
                                  Image.file(
                                    imageFile,
                                    width: 200.0,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _imageFile?.removeAt(index); // Elimina la imagen seleccionada
                                      });
                                    },
                                  ),
                                ],
                              );
                            } else {
                              return const Text('No hay imagen seleccionada');
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                // Upload Button
                ElevatedButton(
                  onPressed: _uploadProduct,
                  child: const Text('Subir Producto'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
