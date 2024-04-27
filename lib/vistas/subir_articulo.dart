import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  List<File>? _selectedImages;
  final List<String> _categories = ['electronica', 'ropa', 'deporte', 'otros'];
  String? _selectedCategory;

  Future<void> _pickImages() async {
    final pickedImages = await ImagePicker().pickMultiImage();
    setState(() {
      _selectedImages = pickedImages.map((image) => File(image.path)).toList();
    });
  }

  Future<String> uploadImage(File imageFile) async {
    final storageRef = FirebaseStorage.instance.ref();
    final imagesRef = storageRef.child("images/");
    final filename = imageFile.path.split('/').last;
    final imageRef = imagesRef.child(filename);
    final uploadTask = imageRef.putFile(imageFile);

    final snapshot = await uploadTask.whenComplete(() => null);
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> _uploadProduct() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Upload images if any
        List<String> imageUrls = [];
        if (_selectedImages != null) { // Using a more descriptive name
          for (final imageFile in _selectedImages!) {
            final imageUrl = await uploadImage(imageFile);
            imageUrls.add(imageUrl);
          }
        }

        // Create product data
        final productData = {
          'name': _nameController.text,
          'description': _descriptionController.text,
          'price': double.parse(_priceController.text),
          'category': _selectedCategory,
          'images': imageUrls,
        };

        // Store product in Firestore
        final productRef = FirebaseFirestore.instance.collection('products').doc();
        await productRef.set(productData);

        // Show success message and navigate back (or implement desired behavior)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto subido exitosamente')),
        );
        Navigator.pop(context); // Assuming this navigates back
      } catch (error) {
        print('Error uploading product: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al subir el producto')),
        );
      }
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
                          itemCount: _selectedImages?.length ??
                              0, // Verifica si _imageFile no es nulo
                          itemBuilder: (BuildContext ctxt, int index) {
                            final imageFile = _selectedImages?[index];
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
                                    icon: const Icon(Icons.remove_circle,
                                        color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _selectedImages?.removeAt(
                                            index); // Elimina la imagen seleccionada
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
