import 'package:flutter/material.dart';
import 'package:tiangucci/vistas/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tiangucci/vistas/usuario.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        // Definir las rutas aquí
        '/': (context) => const MyHomePage(),
        '/perfilUsuario': (context) => const PerfilUsuario(),
        // Agregar más rutas según sea necesario
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent),
        useMaterial3: true,
      ),
    );
  }
}
