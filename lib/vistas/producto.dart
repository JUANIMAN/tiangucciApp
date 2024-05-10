import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tiangucci/vistas/editar_producto.dart';
import 'package:tiangucci/vistas/productos.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail(
      {super.key, required this.product, required this.propietario});
  final bool propietario;
  final Product product;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int _currentIndex = 0;

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
                height: 400, width: 400, fit: BoxFit.cover),
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
        Visibility(
          visible: widget.propietario,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditarArticulo(
                    product: widget.product,
                  ),
                ),
              );
            },
            child: const Text('EDITAR PRODUCTO'),
          ),
        ),
      ]),
    );
  }
}
