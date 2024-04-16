import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  final bool editar;
  const RegisterPage({super.key, required this.editar});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Inicializar los controladores con valores predeterminados o vacíos.
    _nameController = TextEditingController(text: widget.editar ? "JP" : "");
    _emailController =
        TextEditingController(text: widget.editar ? "jp@aragon.com" : "");
    _passwordController =
        TextEditingController(text: widget.editar ? "contraseña" : "");
  }

  @override
  Widget build(BuildContext context) {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                  widget.editar ? 'Editar perfil' : 'Registrarse',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                // Nombre
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'El nombre es obligatorio';
                    }
                    return null;
                  },
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

                // Botón de registro
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Registrarse
                    }
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
