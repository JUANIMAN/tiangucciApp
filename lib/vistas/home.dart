import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiangucci/vistas/articulo.dart';
import 'package:tiangucci/vistas/login.dart';
import 'package:tiangucci/vistas/usuario.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<DocumentSnapshot> _buffer = [];
  final category = ["todos", "ropa", "deporte", "electronica", "otros"];
  String selectedCategory = 'todos';
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _filterProducts(selectedCategory);
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final prefs = await _prefs;
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    setState(() {});
  }

  Future<void> _handleProfile() async {
    if (_isLoggedIn) {
      // Navegar a la vista de perfil
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PerfilUsuario()),
      );
    } else {
      // Navegar a la vista de inicio de sesión
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  void _filterProducts(String category) {
    Stream<QuerySnapshot> stream;
    if (category == 'todos') {
      stream = FirebaseFirestore.instance.collection('products').snapshots();
    } else {
      stream = FirebaseFirestore.instance
          .collection('products')
          .where('category', isEqualTo: category)
          .snapshots();
    }

    stream.listen((QuerySnapshot snapshot) {
      setState(() {
        _buffer = snapshot.docs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Productos"),
        actions: [
          Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.only(left: 15.0, right: 5.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: DropdownButton<String>(
              value: selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                  _filterProducts(selectedCategory);
                });
              },
              items: category
                  .map<DropdownMenuItem<String>>(
                      (value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                  .toList(),
              icon: const Icon(Icons.arrow_drop_down),
              underline: const SizedBox(),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.account_circle,
            ),
            iconSize: 35,
            onPressed: () {
              _handleProfile();
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Dos columnas
          childAspectRatio: 0.6, // Relación de aspecto para la imagen
        ),
        itemCount: _buffer.length, // Usa el buffer aquí
        itemBuilder: (context, index) {
          DocumentSnapshot document = _buffer[index];
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductDetail(propietario: false, productId: document.id),
                ),
              );
            },
            child: Card(
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ClipRRect(
                      // Recortar la imagen con bordes redondeados
                      borderRadius: BorderRadius.circular(14.0),
                      child: Image.network(data['images'][0],
                          width: 200, height: 200, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data['name'],
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '\$${data['price'].toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
