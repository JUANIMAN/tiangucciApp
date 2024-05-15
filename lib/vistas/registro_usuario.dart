import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.editar});
  final bool editar;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitPressed = false;

  // Crea la instancia de FirebaseAuth y Firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _phoneController = TextEditingController();

    if (widget.editar) {
      getUserData();
    }
  }

  Future<void> getUserData() async {
    final User? user = _auth.currentUser;

    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user?.uid).get();

    Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
    _nameController.text = data['username'];
    _emailController.text = data['email'];
    _phoneController.text = data['phoneNumber'];
  }

  Future registerNewUser(String email, String password) async {
    try {
      setState(() {
        _isSubmitPressed = true;
      });
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La contraseña es demasiado débil')),
        );
        setState(() {
          _isSubmitPressed = false;
        });
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Correo electronico invalido')),
        );
        setState(() {
          _isSubmitPressed = false;
        });
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El correo electrónico ya está en uso')),
        );
        setState(() {
          _isSubmitPressed = false;
        });
      }
    }
  }

  Future createUserInFirestore(User user, String username, String phone) async {
    DocumentSnapshot doc =
        await _firestore.collection('users').doc(user.uid).get();

    if (!doc.exists) {
      _firestore.collection('users').doc(user.uid).set({
        'username': username,
        'email': user.email,
        'phoneNumber': phone,
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuario registrado con éxito')),
    );

    setState(() {
      _isSubmitPressed = false;
    });

    Navigator.pop(context);
  }

  Future updateUserProfile(
      User user, String newUsername, String newPhone) async {
    setState(() {
      _isSubmitPressed = true;
    });
    await _firestore.collection('users').doc(user.uid).update({
      'username': newUsername,
      'phoneNumber': newPhone,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil actualizado con éxito')),
    );

    setState(() {
      _isSubmitPressed = false;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isSubmitPressed,
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
                        enabled: !widget.editar,
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
                      if (!widget.editar) const SizedBox(height: 16.0),
                      Visibility(
                        visible: !widget.editar,
                        child: TextFormField(
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
                      ),

                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Teléfono',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor ingrese su número de teléfono';
                          }
                          if (value.length != 10) {
                            return 'Por favor ingrese su número de teléfono a 10 dígitos';
                          }
                          try {
                            int.parse(value);
                          } catch (e) {
                            return 'Por favor ingrese un número de teléfono válido';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            User? user = _auth.currentUser;
                            if (user != null) {
                              // El usuario ya está logueado, actualiza su perfil
                              await updateUserProfile(user,
                                  _nameController.text, _phoneController.text);
                            } else {
                              // El usuario no está logueado, regístralo
                              user = await registerNewUser(
                                  _emailController.text,
                                  _passwordController.text);
                              setState(() {
                                _isSubmitPressed = false;
                              });
                              if (user != null) {
                                await createUserInFirestore(
                                    user,
                                    _nameController.text,
                                    _phoneController.text);
                              }
                            }
                          }
                        },
                        child: Text(
                            widget.editar ? 'Actualizar perfil' : 'Registrar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_isSubmitPressed)
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
