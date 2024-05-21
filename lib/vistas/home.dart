import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiangucci/vistas/producto.dart';
import 'package:tiangucci/vistas/login.dart';
import 'package:tiangucci/vistas/productos.dart';
import 'package:tiangucci/vistas/usuario.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final category = [
    'Todos',
    'Electronica',
    'Ropa',
    'Deporte',
    'Alimentos',
    'Otros'
  ];
  String selectedCategory = 'Todos';
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final prefs = await _prefs;
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    setState(() {});
  }

  Future<void> _handleProfile() async {
    if (_isLoggedIn) {
      // Navegar a la vista de perfil
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PerfilUsuario()),
      );
    } else {
      // Navegar a la vista de inicio de sesión
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  Stream<List<Product>> obtenerProductos(String category) {
    Query query;
    if (category == 'Todos') {
      query = _firestore.collection('products');
    } else {
      query = _firestore
          .collection('products')
          .where('category', isEqualTo: category);
    }

    // Usa snapshots() para obtener un Stream<QuerySnapshot>
    return query.snapshots().map((querySnapshot) => querySnapshot.docs
        .map((doc) => Product.fromFirestore(doc))
        .toList()); // Mapea cada QuerySnapshot a una lista de productos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Productos"),
        actions: [
          Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.only(left: 15.0, right: 5.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton<String>(
              value: selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                  obtenerProductos(selectedCategory);
                });
              },
              items: category
                  .map<DropdownMenuItem<String>>(
                      (value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                  .toList(),
              icon: const Icon(Icons.arrow_drop_down),
              underline: const SizedBox(),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.account_circle,
            ),
            iconSize: 35,
            onPressed: () {
              _handleProfile();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Product>>(
        stream: obtenerProductos(
            selectedCategory), // Pasa el stream a StreamBuilder
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los productos'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay productos disponibles'));
          } else {
            List<Product> products = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Número de columnas
                childAspectRatio: 0.7, // Relación de aspecto para la imagen
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                Product product = products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetail(propietario: false, product: product),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            // Recortar la imagen con bordes redondeados
                            borderRadius: BorderRadius.circular(14.0),
                            child: Image.network(
                              product.images.first,
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
