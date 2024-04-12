import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiangucci/vistas/lista_articulos.dart';
import 'package:tiangucci/vistas/login.dart';
import 'package:tiangucci/vistas/usuario.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _isLoggedIn = false;

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

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Buscaste - Categoria Dama"),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.face_2_outlined,
            ),
            onPressed: () {
              _handleProfile();
            },
            iconSize: 45,
          ),
        ],
      ),
      body: const ProductList(), //esto debe poder precionarse
    );
  }
}
