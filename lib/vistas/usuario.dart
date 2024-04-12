import 'package:flutter/material.dart';
import 'package:tiangucci/vistas/articulo.dart';
import 'package:tiangucci/vistas/productos.dart';

class PerfilUsuario extends StatelessWidget {
  const PerfilUsuario({super.key});

  List<Product> obtenerProductosUsuario() {
    return productList; // Use the existing productList for demo
  }

  @override
  Widget build(BuildContext context) {
    // Obtener la lista de productos del usuario
    final List<Product> productosUsuario = obtenerProductosUsuario();

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
            child: ListView.builder(
              itemCount: productosUsuario.length,
              itemBuilder: (context, index) {
                final producto = productosUsuario[index];
                return MaterialButton(
                  // Enables tapping for edit functionality
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetail(
                          product: producto,
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: Image.asset(producto.image),
                    title: Text(producto.name),
                    subtitle: Text('\$${producto.price.toStringAsFixed(2)}'),
                    trailing: const Icon(Icons.arrow_forward),
                  ),
                );
              },
            ),
          ),

          // Editar perfil
          const Divider(),
          ElevatedButton(
            onPressed: () {
              // Navigate to edit profile screen
            },
            child: const Text('Editar perfil'),
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
