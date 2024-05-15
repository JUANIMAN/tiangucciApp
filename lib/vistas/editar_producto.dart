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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  final List<String> _categories = [
    'Electronica',
    'Ropa',
    'Deporte',
    'Alimentos',
    'Otros'
  ];
  final _deletedImages = [];
  late String _selectedCategory;
  late List<String> _productImages = widget.product.images;
  late List<String> _productImagesCopy;
  late List<File> _selectedImages;
  bool _isSubmitPressed = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _priceController = TextEditingController(text: widget.product.price.toString());
    _descriptionController = TextEditingController(text: widget.product.description);
    _selectedCategory = widget.product.category.name;
    _productImagesCopy = List.from(widget.product.images);
    _selectedImages = [];
  }

  Future<void> _pickImages() async {
    final pickedImages = await ImagePicker().pickMultiImage();
    setState(() {
      _selectedImages = pickedImages.map((image) => File(image.path)).toList();
    });
  }

  Future<void> deleteProductImage(String imageUrl) async {
    var ref = _storage.refFromURL(imageUrl);
    await ref.delete();
  }

  Future<String> uploadProductImage(Product product, File imageFile) async {
    final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = _storage
        .ref()
        .child('productImages/${product.id}/$fileName')
        .putFile(imageFile);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    return downloadURL;
  }

  Future<bool> updateProduct(Product product) async {
    try {
      await _firestore.collection('products').doc(product.id).update({
        'name': product.name,
        'price': product.price,
        'images': product.images,
        'description': product.description,
        'category': product.category.name,
      });
      return true;
    } catch (e) {
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isSubmitPressed,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Editar producto"),
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  child: Column(
                    children: [
                      if (_productImagesCopy.isNotEmpty)
                        SizedBox(
                          height: 200.0,
                          child: ReorderableListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _productImagesCopy.length,
                            itemBuilder: (BuildContext context, int index) {
                              final image = _productImagesCopy[index];
                              return Stack(
                                key: Key('$index'),
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
                            onReorder: (int oldIndex, int newIndex) {
                              setState(() {
                                if (oldIndex < newIndex) {
                                  newIndex -= 1;
                                }
                                final String image = _productImagesCopy.removeAt(oldIndex);
                                _productImagesCopy.insert(newIndex, image);
                              });
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
                        maxLines: 4,
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

                      // Precio
                      const SizedBox(height: 16.0),
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

                      if (_selectedImages.isNotEmpty)
                        SizedBox(
                          height: 200.0,
                          child: ReorderableListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _selectedImages.length,
                            itemBuilder: (BuildContext context, int index) {
                              final imageFile = _selectedImages[index];
                              return Stack(
                                key: Key('$index'),
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
                                        _selectedImages.removeAt(index);
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                            onReorder: (int oldIndex, int newIndex) {
                              setState(() {
                                if (oldIndex < newIndex) {
                                  newIndex -= 1;
                                }
                                final File image = _selectedImages.removeAt(oldIndex);
                                _selectedImages.insert(newIndex, image);
                              });
                            },
                          ),
                        ),

                      // Botón de actualizacion
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () async {
                          if (_selectedImages.isNotEmpty ||
                              _productImagesCopy.isNotEmpty) {
                            setState(() {
                              _isSubmitPressed = true;
                            });

                            // Actualiza la lista original de imágenes
                            _productImages = _productImagesCopy;

                            // Elimina las imágenes indicadas de Firebase Storage
                            if (_deletedImages.isNotEmpty) {
                              for (var image in _deletedImages) {
                                await deleteProductImage(image);
                              }
                            }

                            // Upload images
                            List<String> newImageUrls = _productImages;
                            if (_selectedImages.isNotEmpty) {
                              for (final imageFile in _selectedImages) {
                                final imageUrl = await uploadProductImage(
                                    widget.product, imageFile);
                                newImageUrls.add(imageUrl);
                              }
                            }

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
                            bool isUpdated = await updateProduct(updatedProduct);

                            if (isUpdated) {
                              // Muestra un mensaje de éxito
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                    Text('Producto actualizado con éxito')),
                              );
                            } else {
                              // Muestra un mensaje de Error
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                    Text('El producto no se actualizó correctamente')),
                              );
                            }

                            setState(() {
                              _isSubmitPressed = false;
                            });

                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const PerfilUsuario()),
                              ModalRoute.withName('/'),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Debe haber al menos una imagen que mostrar')),
                            );
                          }
                        },
                        child: const Text('Subir cambios'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_isSubmitPressed)
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
