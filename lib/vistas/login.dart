import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiangucci/vistas/registro_usuario.dart';

import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<bool> _handleLogin() async {
    // Simular inicio de sesión exitoso
    final prefs = await _prefs;
    prefs.setBool('isLoggedIn', true);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const MyHomePage()));
            // Iniciar sesión
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Logo
                const FlutterLogo(size: 128.0),

                // Título
                const SizedBox(height: 16.0),
                Text(
                  'Iniciar sesión',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                // Correo electrónico
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'El correo electrónico es obligatorio';
                    }
                    return null;
                  },
                ),

                // Contraseña
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'La contraseña es obligatoria';
                    }
                    return null;
                  },
                ),

                // Botón de inicio de sesión
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _handleLogin();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const MyHomePage()));
                      // Iniciar sesión
                    }
                  },
                  child: const Text('Iniciar sesión'),
                ),

                // Registrarse
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(editar: false,),
                      ),
                    );
                  },
                  child: const Text('Registrarse'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
