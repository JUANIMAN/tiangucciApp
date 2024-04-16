class Category {
  final String name;

  Category({
    required this.name,
  });
}

class Product {
  final String name;
  final double price;
  final List<String> images; // Cambiar "image" a "images"
  final String description;
  final Category category;

  Product({
    required this.name,
    required this.price,
    required this.images, // Se crea una lista de imágenes
    required this.description,
    required this.category,
  });
}

final List<Product> productList = [
  Product(
    name: 'Tenis running',
    price: 1999.99,
    images: [
      Assets.imagenZapatos1, // URL de la imagen principal
      Assets.imagenZapatos2, // URL de la imagen adicional 1
      Assets.imagenZapatos3, // URL de la imagen adicional 2
      Assets.imagenZapatos4, // URL de la imagen adicional 3
    ],
    description: 'Tenis cómodos para correr o hacer ejercicio.',
    category: Category(name: 'ropa'),
  ),
  Product(
    name: 'Bolso de Cuero',
    price: 2499.99,
    images: [
      Assets.imagenBolso,
    ],
    description: 'Elegante bolso de cuero para ocasiones especiales.',
    category: Category(name: 'ropa'),
  ),
  Product(
    name: 'Reloj inteligente',
    price: 999.99,
    images: [
      Assets.imagenReloj,
    ],
    description: 'Un reloj inteligente con seguimiento de actividad, notificaciones de mensajes y monitorización del ritmo cardíaco.',
    category: Category(name: 'electronica'),
  ),
  Product(
    name: 'Playera Deportiva',
    price: 999.99,
    images: [
      Assets.imagenPlayera,
    ],
    description: 'Camiseta ligera y transpirable para hacer ejercicio o practicar deportes.',
    category: Category(name: 'ropa'),
  ),
  Product(
    name: 'Pantalones Deportivos',
    price: 1299.99,
    images: [
      Assets.imagenPantalones,
    ],
    description: 'Pantalones cómodos y ajustables para entrenamiento o actividades al aire libre.',
    category: Category(name: 'ropa'),
  ),
  Product(
    name: 'Botella de Agua',
    price: 499.99,
    images: [
      Assets.imagenBotella,
    ],
    description: 'Botella de agua práctica y ecológica para llevar al gimnasio o a cualquier lugar.',
    category: Category(name: 'deporte'),
  ),
  Product(
    name: 'Auriculares Inalámbricos',
    price: 1499.99,
    images: [
      Assets.imagenAuriculares
    ],
    description: 'Auriculares inalámbricos con sonido de alta calidad para disfrutar de música mientras haces ejercicio.',
    category: Category(name: 'electronica'),
  ),
  Product(
    name: 'Mancuernas Ajustables',
    price: 1099.99,
    images: [
      Assets.imagenMancuernas
    ],
    description: 'Mancuernas ajustables para entrenamiento de fuerza en casa o en el gimnasio.',
    category: Category(name: 'otros'),
  ),
  // Agrega más productos aquí...
];

mixin Assets {
  static const String imagePath = 'assets/images';
  static const String imagenZapatos1 = '$imagePath/nike1.png';
  static const String imagenZapatos2 = '$imagePath/nike2.png';
  static const String imagenZapatos3 = '$imagePath/nike3.png';
  static const String imagenZapatos4 = '$imagePath/nike4.png';
  static const String imagenBolso = '$imagePath/bolso.jpeg';
  static const String imagenReloj = '$imagePath/reloj.png';
  static const String imagenPlayera = '$imagePath/playera.jpeg';
  static const String imagenPantalones = '$imagePath/pantalones.jpeg';
  static const String imagenBotella = '$imagePath/botella.jpeg';
  static const String imagenAuriculares = '$imagePath/auriculares.jpeg';
  static const String imagenMancuernas = '$imagePath/mancuernas.jpeg';
}
