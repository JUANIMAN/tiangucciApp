import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tiangucci/vistas/editar_articulo.dart';
import 'package:tiangucci/vistas/productos.dart';

class ProductDetail extends StatelessWidget {
  final bool propietario;
  final Product product;

  const ProductDetail(
      {super.key, required this.product, required this.propietario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (product.images.length > 1)
              CarouselSlider(
                items: product.images.map((image) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Image.asset(image, fit: BoxFit.cover);
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 300.0,
                  viewportFraction: 1.0,
                ),
              )
            else if (product.images.isNotEmpty)
              Image.asset(product.images.first,
                  height: 300.0, width: double.infinity, fit: BoxFit.cover),
            const SizedBox(height: 20),
            Text(
              product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              product.description,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: propietario,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditarArticulo(
                        product: product,
                      ),
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
