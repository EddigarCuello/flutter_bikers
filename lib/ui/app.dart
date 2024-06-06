import 'package:flutter/material.dart';
import 'package:flutter_application/ui/auth/ingreso.dart';
import 'package:flutter_application/ui/auth/login.dart';
import 'package:flutter_application/ui/auth/registro.dart';
import 'package:flutter_application/ui/auth/registroAdministrador.dart';
import 'package:flutter_application/ui/auth/registroConductor.dart';
import 'package:flutter_application/ui/pages/Motos/DriverData.dart';
import 'package:flutter_application/ui/pages/Motos/add.dart';
import 'package:flutter_application/ui/pages/Motos/eliminar.dart';
import 'package:flutter_application/ui/pages/Motos/list_inicio.dart';
import 'package:flutter_application/ui/pages/codigoTransporte.dart';
import 'package:flutter_application/ui/pages/home/principal.dart';
import 'package:flutter_application/ui/pages/home/principal_conductores.dart';
import 'package:flutter_application/ui/pages/pagosConductor.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      title: 'Material App',
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/apertura': (context) => const ListaMotos(),
        '/home': (context) =>  HomePage(),
        '/codigo': (context) => PdfViewerPage(),
        '/pago': (context) => const PagoConductor(),
        '/homeConductores': (context) => const HomeConductores(),
        '/addEstudiante': (context) => AdicionarEstudiante(),
        '/eliminarEstudiante': (context) => const EliminarEstudiante(),
        '/registro': (context) => const Registro(),
        '/registroConductor': (context) => registroConductor(),
        '/registroAdministrador': (context) => registroAdministrador(),
        '/ingreso': (context) => const ingreso(),
        '/conductor_data': (context) => const ConductorData()
        // Agregar la ruta para la página de eliminar
      },
    );
  }
}
