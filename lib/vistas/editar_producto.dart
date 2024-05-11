import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiangucci/vistas/productos.dart';
import 'package:tiangucci/vistas/usuario.dart';

class EditarProducto extends StatefulWidget {
  const EditarProducto({super.key, required this.product});
  final Product product;

  @override
  State<EditarProducto> createState() => _EditarProductoState();
}

class _EditarProductoState extends State<EditarProducto> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  final List<String> _categories = ['Electronica', 'Ropa', 'Deporte', 'Alimentos', 'Otros'];
  final List<String> _deletedImages = [];
  late String _selectedCategory;
  late List<String> _productImages = widget.product.images;
  late List<String> _productImagesCopy;
  List<File>? _selectedImages;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _priceController = TextEditingController(text: widget.product.price.toString());
    _descriptionController = TextEditingController(text: widget.product.description);
    _selectedCategory = widget.product.category.name;
    _productImagesCopy = List.from(widget.product.images);
  }

  Future<void> _pickImages() async {
    final pickedImages = await ImagePicker().pickMultiImage();
    setState(() {
      _selectedImages = pickedImages.map((image) => File(image.path)).toList();
    });
  }

  Future<String> uploadImage(File imageFile) async {
    final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final Reference ref = FirebaseStorage.instance.ref().child(fileName);
    final UploadTask uploadTask = ref.putFile(imageFile);
    final downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> deleteImages(List<String> imageUrls) async {
    for (var imageUrl in imageUrls) {
      var ref = FirebaseStorage.instance.refFromURL(imageUrl);
      await ref.delete();
    }
  }

  Future<void> updateProduct(Product product) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(product.id)
        .update({
      'name': product.name,
      'price': product.price,
      'images': product.images,
      'description': product.description,
      'category': product.category.name,
    });
  }

  @override
  Widget build(BuildContext context) {
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
                SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _productImagesCopy.length,
                    itemBuilder: (BuildContext context, int index) {
                      final image = _productImagesCopy[index];
                      return Stack(
                        alignment: Alignment.topRight,
                        children: <Widget>[
                          Image.network(
                            image,
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.red),
                            onPressed: () {
                              setState(() {
                                // Añade la imagen a la lista de imágenes eliminadas
                                _deletedImages.add(image);
                                // Elimina la imagen de la lista _productImagesCopy
                                _productImagesCopy.removeAt(index);
                              });
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _nameController,
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
                  controller: _descriptionController,
                  maxLines: 2,
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
                  controller: _priceController,
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
                      _selectedCategory = value!;
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
                  child: const Text('Agregar imagenes'),
                ),

                SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedImages?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
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
                                  _selectedImages?.removeAt(index);
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

                // Botón de actualizacion
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    // Actualiza la lista original de imágenes
                    _productImages = _productImagesCopy;

                    // Upload images if any
                    List<String> newImageUrls = _productImages;
                    if (_selectedImages != null) {
                      for (final imageFile in _selectedImages!) {
                        final imageUrl = await uploadImage(imageFile);
                        newImageUrls.add(imageUrl);
                      }
                    }

                    print(_productImages);

                    // Elimina las imágenes indicadas de Firebase Storage
                    deleteImages(_deletedImages);

                    // Crea un nuevo objeto Product con los valores actualizados
                    Product updatedProduct = Product(
                      id: widget.product.id,
                      name: _nameController.text,
                      price: double.parse(_priceController.text),
                      images: newImageUrls,
                      description: _descriptionController.text,
                      category: Category(name: _selectedCategory),
                    );

                    // Actualiza el documento del producto en Firestore
                    updateProduct(updatedProduct);

                    // Muestra un mensaje de éxito
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Producto actualizado con éxito')),
                    );
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const PerfilUsuario()),
                      ModalRoute.withName('/'),
                    );
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
