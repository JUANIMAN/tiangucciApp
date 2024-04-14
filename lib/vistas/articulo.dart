import 'package:flutter/material.dart';
import 'package:tiangucci/vistas/editar_articulo.dart';
import 'package:tiangucci/vistas/productos.dart';

class ProductDetail extends StatelessWidget {
  final bool propietario;
  final Product product;

  const ProductDetail({super.key, required this.product, required this.propietario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Producto'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(product.image),
            const SizedBox(height: 20),
            Text(
              product.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              product.description,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Visibility(
                visible: propietario,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditarArticulo(product: product,),
                      ),
                    );
                  },
                  child: const Text('EDITAR PRODUCTO'),
                ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
class Articulo extends StatefulWidget {
  const Articulo({super.key, required this.title});

  final String title;

  @override
  State<Articulo> createState() => _Articulo();
}

class _Articulo extends State<Articulo> {
  @override
  Widget build(BuildContext context) {
    String titulo = "PELUCHE SPRINGTRAP";
    double precio = 255.89;
    String descripcion = "Peluche de springtrap de 30 x 30 cm, felpa, oficial";
    String rutaFoto =
        "https://m.media-amazon.com/images/I/71Vv3-pA3ML._AC_UF894,1000_QL80_.jpg";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
              rutaFoto,
              width: 200, // Ancho deseado de la imagen
              height: 200, // Alto deseado de la imagen
            ),
            Text(titulo),
            Text("Precio: $precio"),
            Text(descripcion),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditarArticulo(
                            titulo, precio, "peluches", descripcion, rutaFoto,
                            title: "Articulo")));
              },
              child: const Text('EDITAR'),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
 */
