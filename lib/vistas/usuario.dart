import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiangucci/vistas/articulo.dart';
import 'package:tiangucci/vistas/home.dart';
import 'package:tiangucci/vistas/productos.dart';
import 'package:tiangucci/vistas/registro_usuario.dart';
import 'package:tiangucci/vistas/subir_articulo.dart';

class PerfilUsuario extends StatelessWidget {
  const PerfilUsuario({super.key});

  List<Product> obtenerProductosUsuario() {
    return productList; // Use the existing productList for demo
  }

  @override
  Widget build(BuildContext context) {
    // Obtener la lista de productos del usuario
    final List<Product> productosUsuario = obtenerProductosUsuario();
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    Future<bool> signOut() async {
      // Cerrar sesion
      final prefs = await _prefs;
      prefs.setBool('isLoggedIn', false);
      return true;
    }

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
                          propietario: true,
                          product: producto,
                        ),
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
                        child: Image.asset(
                          producto.images.first,
                          fit: BoxFit
                              .cover, // Rellena el contenedor manteniendo la relación de aspecto
                        ),
                      ),
                    ),
                    title: Text(producto.name),
                    subtitle: Text('\$${producto.price.toStringAsFixed(2)}'),
                    trailing: const Icon(Icons.arrow_forward),
                  ),
                );
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
                      builder: (context) => const RegisterPage(editar: true,),
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
              signOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const MyHomePage()));
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
