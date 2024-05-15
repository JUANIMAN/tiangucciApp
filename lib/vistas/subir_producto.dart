import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SubirProducto extends StatefulWidget {
  const SubirProducto({super.key});

  @override
  State<SubirProducto> createState() => _SubirProductoState();
}

class _SubirProductoState extends State<SubirProducto> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  late List<File> _selectedImages;
  final List<String> _categories = [
    'Electronica',
    'Ropa',
    'Deporte',
    'Alimentos',
    'Otros'
  ];
  String? _selectedCategory;
  bool _isSubmitPressed = false;

  @override
  void initState() {
    super.initState();
    _selectedImages = [];
  }

  Future<void> pickImages() async {
    final pickedImages = await ImagePicker().pickMultiImage();
    setState(() {
      _selectedImages = pickedImages.map((image) => File(image.path)).toList();
    });
  }

  Future<String> createEmptyDocument() async {
    // Crea un nuevo documento en la colección 'products' y obtén su ID
    DocumentReference docRef = await _firestore.collection('products').add({});
    return docRef.id;
  }

  Future<String> uploadProductImage(String productId, File imageFile) async {
    final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = _storage
        .ref()
        .child('productImages/$productId/$fileName')
        .putFile(imageFile);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    return downloadURL;
  }

  Future<bool> uploadProduct() async {
    try {
      // Obtén el UID del usuario actual
      final User? user = _auth.currentUser;

      String productId = await createEmptyDocument();

      // Upload images
      List<String> imageUrls = [];
      for (final imageFile in _selectedImages) {
        final imageUrl = await uploadProductImage(productId, imageFile);
        imageUrls.add(imageUrl);
      }

      // Create product data with user ID
      final productData = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'price': double.parse(_priceController.text),
        'category': _selectedCategory,
        'images': imageUrls,
        'userId': user?.uid,
      };

      // Store product in Firestore
      await _firestore.collection('products').doc(productId).set(productData);

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
          title: const Text('Subir Producto'),
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
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
                        onPressed: pickImages,
                        child: const Text('Seleccionar imagenes'),
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
                                        // Elimina la imagen seleccionada
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
                                final File image =
                                    _selectedImages.removeAt(oldIndex);
                                _selectedImages.insert(newIndex, image);
                              });
                            },
                          ),
                        ),

                      // Upload Button
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate() &&
                                _selectedImages.isNotEmpty) {
                              setState(() {
                                _isSubmitPressed = true;
                              });

                              bool isUpload = await uploadProduct();

                              if (isUpload) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Producto subido exitosamente')),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Error al subir el producto')),
                                );
                              }

                              setState(() {
                                _isSubmitPressed = false;
                              });

                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Selecciona al menos una imagen')),
                              );
                            }
                          },
                          child: const Text('Subir producto'),
                        ),
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
