import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiangucci/vistas/home.dart';
import 'package:tiangucci/vistas/registro_usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  bool _isLogging = false;

  // Crea la instancia de FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> handleLogin(String email, String password) async {
    try {
      setState(() {
        _isLogging = true;
      });

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Inicio de sesión exitoso
      final prefs = await _prefs;
      prefs.setBool('isLoggedIn', true);

      setState(() {
        _isLogging = false;
      });

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MyHomePage()),
        (Route<dynamic> route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Correo electronico invalido')),
        );
        setState(() {
          _isLogging = false;
        });
      } else if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Credenciales invalidas')),
        );
        setState(() {
          _isLogging = false;
        });
      }
    } catch (e) {
      // Otros errores
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isLogging,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
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
                            return 'Por favor ingrese su correo electrónico';
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
                            return 'Por favor ingrese su contraseña';
                          }
                          return null;
                        },
                      ),

                      // Botón de inicio de sesión
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await handleLogin(_emailController.text,
                                _passwordController.text);
                          }
                        },
                        child: const Text('Iniciar sesión'),
                      ),

                      // ¿Olvidaste tu contraseña?
                      const SizedBox(height: 16.0),
                      TextButton(
                        onPressed: () {},
                        child: const Text('¿Olvidaste tu contraseña?'),
                      ),

                      // Registrarse
                      const SizedBox(height: 16.0),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(
                                editar: false,
                              ),
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
            if (_isLogging)
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
