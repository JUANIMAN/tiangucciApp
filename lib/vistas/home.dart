import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiangucci/vistas/articulo.dart';
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
  final category = ["todos", "ropa", "deporte", "electronica", "otros"];
  String selectedCategory = 'todos';
  bool _isLoggedIn = false;

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

  List<Product> _filterProducts(String selectedCategory) {
    if (selectedCategory == 'todos') {
      return productList; // Mostrar todos los productos
    } else {
      return productList
          .where((product) => product.category.name == selectedCategory)
          .toList(); // Filtrar por categoría seleccionada
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLogin();
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
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: DropdownButton<String>(
              value: selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
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
          IconButton(
            icon: const Icon(
              Icons.outbond,
            ),
            iconSize: 35,
            onPressed: () {
              FirebaseAuth.instance.signOut();
               Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (Route<dynamic> route) => false,
                      );
              print("Salida");
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Dos columnas
          childAspectRatio: 0.6, // Relación de aspecto para la imagen
        ),
        itemCount: _filterProducts(selectedCategory).length,
        itemBuilder: (context, index) {
          final product = _filterProducts(selectedCategory)[index];
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
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ClipRRect(
                      // Recortar la imagen con bordes redondeados
                      borderRadius: BorderRadius.circular(14.0),
                      child:
                          Image.asset(product.images.first, fit: BoxFit.cover),
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
      ),
    );
  }
}
