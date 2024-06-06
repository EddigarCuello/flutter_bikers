import 'package:flutter/material.dart';
import 'package:flutter_application/domain/control/controlAuth.dart';
import 'package:flutter_application/domain/modelos/Persona.dart';
import 'package:get/get.dart';

class registroConductor extends StatefulWidget {
  @override
  _RegistroConductorState createState() => _RegistroConductorState();
}

class _RegistroConductorState extends State<registroConductor> {
  final ControlUserAuth _authController = Get.find();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();

  String password = '';
  String confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0e0c19),
        elevation: 0, // Eliminar sombra y borde del AppBar
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xFF6750a4),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/registro');
          },
        ),
      ),
      key: UniqueKey(), // Agrega una clave única al Scaffold
      body: Container(
        padding: EdgeInsets.only(top: 0),
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0e0c19), Color(0xFF0e0c19)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 0),
              Image.asset(
                '/logo1.png', // Corrige la ruta de la imagen
                width: 333,
                height: 302,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 6.0),
              const Text(
                "Administrador",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              Column(
                children: [
                  SizedBox(height: 20),
                  // Input 1: Correo electrónico
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Correo electrónico',
                      hintStyle:
                          TextStyle(color: Color.fromARGB(151, 255, 255, 255)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF775776)),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF775776)),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  // Input 2: Nombre
                  TextFormField(
                    controller: _nombreController,
                    decoration: InputDecoration(
                      hintText: 'Nombre',
                      hintStyle:
                          TextStyle(color: Color.fromARGB(151, 255, 255, 255)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF775776)),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF775776)),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  // Input 3: Apellido
                  TextFormField(
                    controller: _apellidoController,
                    decoration: InputDecoration(
                      hintText: 'Apellido',
                      hintStyle:
                          TextStyle(color: Color.fromARGB(151, 255, 255, 255)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF775776)),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF775776)),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  // Input 4: Cédula
                  TextFormField(
                    controller: _cedulaController,
                    decoration: InputDecoration(
                      hintText: 'Cédula',
                      hintStyle:
                          TextStyle(color: Color.fromARGB(151, 255, 255, 255)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF775776)),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF775776)),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  // Input 5: Contraseña
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Contraseña',
                      hintStyle:
                          TextStyle(color: Color.fromARGB(151, 255, 255, 255)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF775776)),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF775776)),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  // Input 6: Confirmar Contraseña
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Confirmar Contraseña',
                      hintStyle:
                          TextStyle(color: Color.fromARGB(151, 255, 255, 255)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF775776)),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF775776)),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: 280,
                height: 40,
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF775776),
                    side:
                        BorderSide(color: const Color(0xFF775776), width: 2.0),
                  ),
                  child: const Text(
                    "Registrarse",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }

  void _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Las contraseñas no coinciden',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Persona user = Persona(
        nombre: _nombreController.text,
        apellido: _apellidoController.text,
        correo: _emailController.text,
        password: _passwordController.text,
        rol: 'Driver',
        cedula: '1095298156');

    await _authController.crearUser(user);

    if (_authController.mensajesUser == 'Proceso Realizado Correctamente') {
      Get.offNamed('/homeConductores');
    } else {
      Get.snackbar(
        'Error',
        _authController.mensajesUser,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
