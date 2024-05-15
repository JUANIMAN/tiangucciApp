import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String name;

  Category({
    required this.name,
  });
}

class Product {
  final String id;
  final String name;
  final double price;
  final List<String> images;
  final String description;
  final Category category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.images,
    required this.description,
    required this.category,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'],
      price: data['price'].toDouble(),
      images: List<String>.from(data['images']),
      description: data['description'],
      category: Category(name: data['category']),
    );
  }
}
