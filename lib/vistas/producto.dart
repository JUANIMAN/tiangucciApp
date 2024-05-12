import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tiangucci/vistas/editar_producto.dart';
import 'package:tiangucci/vistas/productos.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key, required this.product, required this.propietario});
  final bool propietario;
  final Product product;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  int _currentIndex = 0;

  Future<void> deleteProductImage(Product product) async {
    for (var image in product.images) {
      var ref = _storage.refFromURL(image);
      await ref.delete();
    }
  }

  Future<void> deleteProduct(Product product) async {
    CollectionReference products = _firestore.collection('products');

    try {
      await products.doc(product.id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto eliminado exitosamente')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo eliminar el producto')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Producto'),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (widget.product.images.length > 1)
          CarouselSlider(
            items: widget.product.images.map((image) {
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Hero(
                              tag: 'imageHero',
                              child: PhotoView(
                                  imageProvider: NetworkImage(image),
                                  initialScale:
                                      PhotoViewComputedScale.contained * 1,
                                  minScale:
                                      PhotoViewComputedScale.contained * 1,
                                  maxScale: PhotoViewComputedScale.covered));
                        },
                      );
                    },
                    child: Image.network(image,
                        width: double.infinity, fit: BoxFit.cover),
                  );
                },
              );
            }).toList(),
            options: CarouselOptions(
              height: 400,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          )
        else if (widget.product.images.isNotEmpty)
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Hero(
                    tag: 'imageHero', // Same tag as the first Hero
                    child: PhotoView(
                      imageProvider: NetworkImage(widget.product.images.first),
                      initialScale: PhotoViewComputedScale.contained * 1,
                      minScale: PhotoViewComputedScale.contained * 1,
                      maxScale: PhotoViewComputedScale.covered,
                    ),
                  );
                },
              );
            },
            child: Image.network(widget.product.images.first,
                height: 400, width: double.infinity, fit: BoxFit.cover),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.product.images.map((url) {
            int index = widget.product.images.indexOf(url);
            return Container(
              width: 8.0,
              height: 8.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? Theme.of(context).primaryColor
                    : const Color.fromRGBO(0, 0, 0, 0.4),
              ),
            );
          }).toList(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            widget.product.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            '\$${widget.product.price.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 20),
          ),
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Descripción",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            widget.product.description,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Visibility(
              visible: widget.propietario,
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditarProducto(
                            product: widget.product,
                          ),
                        ),
                      );
                    },
                    child: const Text('EDITAR'),
                  ),
                  const SizedBox(height: 10), // Espacio entre los botones
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white),
                    onPressed: () async {
                      await deleteProductImage(widget.product);
                      await deleteProduct(widget.product);
                    },
                    child: const Text('ELIMINAR'),
                  ),
                ],
              ),
            )),
      ]),
    );
  }
}
