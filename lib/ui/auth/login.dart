import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart'; // For input formatting (optional)

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _validateEmail = false;
  bool _validatePassword = false;

  void _login() {
    setState(() {
      _validateEmail = _emailController.text.isEmpty;
      _validatePassword = _passwordController.text.isEmpty;
    });

    if (!_validateEmail && !_validatePassword) {
      // Implement your login logic with API or Firebase here
      // Navigate to the next page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        // Make the content occupy the full available space
        child: Container(
          padding: EdgeInsets.only(top: 70.0),
          height: double
              .infinity, // This makes the body occupy the full screen height
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0e0c19), Color(0xFF0e0c19)],
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20.0),
                Image.asset(
                  '/logo1.png', // Ruta de la imagen en tus activos
                  width: 333, // Ancho deseado de la imagen
                  height: 302, // Alto deseado de la imagen
                  fit: BoxFit
                      .contain, // Ajuste de la imagen dentro del contenedor
                ),
                const SizedBox(height: 50.0, width: 400),
                Padding(
                  padding: const EdgeInsets.only(
                      right:
                          180.0), // Ajusta el relleno del lado izquierdo según sea necesario
                  child: const Text(
                    "Iniciar Sesion",
                    style: TextStyle(
                      color: Colors.white, // Color blanco
                      fontWeight: FontWeight.bold, // Texto en negrita
                    ),
                  ),
                ),
                SizedBox(
                  width: 280,
                  height: 40, // Ancho deseado del botón
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/ingreso');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF775776),
                      side: BorderSide(
                          color: const Color(0xFF775776), width: 2.0),
                    ),
                    child: const Text(
                      "Log In",
                      style: TextStyle(
                        color:
                            Colors.white, // Cambia el color del texto a blanco
                        fontWeight:
                            FontWeight.bold, // Hace que el texto sea negrita
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  width: 280,
                  height: 40, // Ancho deseado del botón
                ),
                const SizedBox(height: 5.0, width: 400),
                Padding(
                  padding: const EdgeInsets.only(
                      right:
                          190.0), // Ajusta el relleno del lado izquierdo según sea necesario
                  child: const Text(
                    "Registrarse",
                    style: TextStyle(
                      color: Colors.white, // Color blanco
                      fontWeight: FontWeight.bold, // Texto en negrita
                    ),
                  ),
                ),
                SizedBox(
                  width: 280,
                  height: 40, // Ancho deseado del botón
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/registro');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0e0c19),
                      // Cambia el color del botón a rojo
                      // Puedes ajustar otros atributos del botón aquí según sea necesario
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color:
                            Colors.white, // Cambia el color del texto a blanco
                        fontWeight:
                            FontWeight.bold, // Hace que el texto sea negrita
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
