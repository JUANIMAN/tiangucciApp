import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tiangucci/vistas/editar_articulo.dart';

class ProductDetail extends StatefulWidget {
  final String productId;
  final bool propietario;

  const ProductDetail(
      {super.key, required this.productId, required this.propietario});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  late Future<DocumentSnapshot> _productFuture;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _productFuture = FirebaseFirestore.instance
        .collection('products')
        .doc(widget.productId)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _productFuture,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Text('Algo salió mal');
        }

        Map<String, dynamic> product =
            snapshot.data!.data()! as Map<String, dynamic>;
        List<String> images = List<String>.from(product['images'] as List);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(product['name']),
          ),
          body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (images.length > 1)
              CarouselSlider(
                items: images.map((image) {
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
                                      initialScale: PhotoViewComputedScale.contained * 1,
                                      minScale: PhotoViewComputedScale.contained * 1,
                                      maxScale: PhotoViewComputedScale.covered));
                            },
                          );
                        },
                        child: Image.network(image,
                            width: 400, height: 400, fit: BoxFit.cover),
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
            else if (images.isNotEmpty)
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Hero(
                        tag: 'imageHero', // Same tag as the first Hero
                        child: PhotoView(
                          imageProvider: NetworkImage(images.first),
                          initialScale: PhotoViewComputedScale.contained * 1,
                          minScale: PhotoViewComputedScale.contained * 1,
                          maxScale: PhotoViewComputedScale.covered,
                        ),
                      );
                    },
                  );
                },
                child: Image.network(images.first,
                    height: 400, width: 400, fit: BoxFit.cover),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: images.map((url) {
                int index = images.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 2.0),
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
                product['name'],
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '\$${product['price'].toStringAsFixed(2)}',
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
                product['description'],
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: widget.propietario,
              child: ElevatedButton(
                onPressed: () {
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditarArticulo(
                        product: widget.product,
                      ),
                    ),
                  );*/
                },
                child: const Text('EDITAR PRODUCTO'),
              ),
            ),
          ]),
        );
      },
    );
  }
}
