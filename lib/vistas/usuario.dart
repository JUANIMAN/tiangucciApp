import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiangucci/vistas/producto.dart';
import 'package:tiangucci/vistas/productos.dart';
import 'package:tiangucci/vistas/registro_usuario.dart';
import 'package:tiangucci/vistas/subir_producto.dart';

import 'home.dart';

class PerfilUsuario extends StatefulWidget {
  const PerfilUsuario({super.key});

  @override
  State<PerfilUsuario> createState() => _PerfilUsuarioState();
}

class _PerfilUsuarioState extends State<PerfilUsuario> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  late Future<List<Product>> futureProductosUsuario;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    futureProductosUsuario = obtenerProductosUsuario();
  }

  Future<bool> signOutUser() async {
    // Cerrar sesion
    await FirebaseAuth.instance.signOut();

    final prefs = await _prefs;
    prefs.setBool('isLoggedIn', false);
    return true;
  }

  Future<List<Product>> obtenerProductosUsuario() async {
    User? usuarioActual = FirebaseAuth.instance.currentUser;
    String userId = usuarioActual?.uid ?? '';

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('userId', isEqualTo: userId)
        .get();

    return querySnapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Mi perfil'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Foto de perfil
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(Assets.imagenUsuario),
          ),

          // Nombre y correo
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Nombre de usuario',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'correo@ejemplo.com',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),

          // Productos a la venta
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Productos a la venta',
              style: TextStyle(fontSize: 18),
            ),
          ),

          // Mostrar la lista de productos del usuario
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: futureProductosUsuario,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text('Error al cargar los productos'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No hay productos disponibles'));
                } else {
                  List<Product> products = snapshot.data!;
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      Product product = products[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetail(
                                  propietario: true, product: product),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: SizedBox(
                            // Contenedor con tamaño fijo
                            width: 60,
                            height: 60,
                            child: ClipRRect(
                              // Recortar la imagen con bordes redondeados (opcional)
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                product.images.first,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(product.name),
                          subtitle:
                              Text('\$${product.price.toStringAsFixed(2)}'),
                          trailing: const Icon(Icons.arrow_forward),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),

          const Divider(),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center the buttons horizontally
            children: [
              ElevatedButton(
                onPressed: () {
                  // Navegar a la vista editar Perfil
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(
                        editar: true,
                      ),
                    ),
                  );
                },
                child: const Text('Editar Perfil'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  // Navegar a la vista subir producto
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SubirProducto()),
                  );
                },
                child: const Text('Subir producto'),
              ),
            ],
          ),

          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              // Cerrar sesion y volver al home
              signOutUser();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const MyHomePage()),
                (Route<dynamic> route) => false,
              );
            },
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}

mixin Assets {
  static const String imagePath = 'assets/images';
  static const String imagenUsuario = '$imagePath/perfil.png';
}
