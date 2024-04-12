
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
    name: 'Zapatillas Deportivas',
    price: 1999.99,
    image: Assets.imageZapatos,
    description: 'Zapatillas cómodas para correr o hacer ejercicio.',
  ),
  Product(
    name: 'Bolso de Cuero',
    price: 2499.99,
    image: Assets.imageBolso,
    description: 'Elegante bolso de cuero para ocasiones especiales.',
  ),
  Product(
      name: 'Reloj inteligente',
      price: 999.99,
      image: Assets.imageReloj,
      description:
      'Un reloj inteligente con seguimiento de actividad, notificaciones de mensajes y monitorización del ritmo cardíaco. Perfecto para mantenerse activo y conectado durante todo el día.')
  // Agrega más productos aquí...
];

mixin Assets {
  static const String imagePath = 'assets/images';
  static const String imageZapatos = '$imagePath/zapatos.jpeg';
  static const String imageBolso = '$imagePath/bolso.jpeg';
  static const String imageReloj = '$imagePath/reloj.png';
}
