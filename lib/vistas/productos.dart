class Product {
  final String name;
  final double price;
  final String image;
  final String description;

  Product({
    required this.name,
    required this.price,
    required this.image,
    required this.description,
  });
}

final List<Product> productList = [
  Product(
    name: 'Tenis running',
    price: 1999.99,
    image: Assets.imagenZapatos,
    description: 'Tenis cómodos para correr o hacer ejercicio.',
  ),
  Product(
    name: 'Bolso de Cuero',
    price: 2499.99,
    image: Assets.imagenBolso,
    description: 'Elegante bolso de cuero para ocasiones especiales.',
  ),
  Product(
      name: 'Reloj inteligente',
      price: 999.99,
      image: Assets.imagenReloj,
      description:
          'Un reloj inteligente con seguimiento de actividad, notificaciones de mensajes y monitorización del ritmo cardíaco. Perfecto para mantenerse activo y conectado durante todo el día.',
  ),
  Product(
    name: 'Playera Deportiva',
    price: 999.99,
    image: Assets.imagenPlayera,
    description: 'Camiseta ligera y transpirable para hacer ejercicio o practicar deportes.',
  ),
  Product(
    name: 'Pantalones Deportivos',
    price: 1299.99,
    image: Assets.imagenPantalones,
    description: 'Pantalones cómodos y ajustables para entrenamiento o actividades al aire libre.',
  ),
  Product(
    name: 'Botella de Agua',
    price: 499.99,
    image: Assets.imagenBotella,
    description: 'Botella de agua práctica y ecológica para llevar al gimnasio o a cualquier lugar.',
  ),
  Product(
    name: 'Auriculares Inalámbricos',
    price: 1499.99,
    image: Assets.imagenAuriculares,
    description: 'Auriculares inalámbricos con sonido de alta calidad para disfrutar de música mientras haces ejercicio.',
  ),
  Product(
    name: 'Mancuernas Ajustables',
    price: 1099.99,
    image: Assets.imagenMancuernas,
    description: 'Mancuernas ajustables para entrenamiento de fuerza en casa o en el gimnasio.',
  ),
  // Agrega más productos aquí...
];

mixin Assets {
  static const String imagePath = 'assets/images';
  static const String imagenZapatos = '$imagePath/zapatos.jpeg';
  static const String imagenBolso = '$imagePath/bolso.jpeg';
  static const String imagenReloj = '$imagePath/reloj.png';
  static const String imagenPlayera = '$imagePath/playera.jpeg';
  static const String imagenPantalones = '$imagePath/pantalones.jpeg';
  static const String imagenBotella = '$imagePath/botella.jpeg';
  static const String imagenAuriculares = '$imagePath/auriculares.jpeg';
  static const String imagenMancuernas = '$imagePath/mancuernas.jpeg';
}
