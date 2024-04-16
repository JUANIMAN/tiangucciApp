import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tiangucci/vistas/editar_articulo.dart';
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
        title: Text(widget.product.name),
      ),
      body: Column(children: [
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
                          return PhotoView(
                              imageProvider: AssetImage(widget.product.images.first),
                              initialScale: PhotoViewComputedScale.contained * 1,
                              minScale: PhotoViewComputedScale.contained * 1,
                              maxScale: PhotoViewComputedScale.covered);
                        },
                      );
                    },
                    child: Image.asset(image, fit: BoxFit.cover),
                  );
                },
              );
            }).toList(),
            options: CarouselOptions(
              height: 300.0,
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
                  return PhotoView(
                      imageProvider: AssetImage(widget.product.images.first),
                      initialScale: PhotoViewComputedScale.contained * 1,
                      minScale: PhotoViewComputedScale.contained * 1,
                      maxScale: PhotoViewComputedScale.covered);
                },
              );
            },
            child: Image.asset(widget.product.images.first, height: 300.0, fit: BoxFit.fitWidth),
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
        const SizedBox(height: 20),
        Text(
          widget.product.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          '\$${widget.product.price.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Text(
          widget.product.description,
          textAlign: TextAlign.justify,
          style: const TextStyle(fontSize: 16),
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
