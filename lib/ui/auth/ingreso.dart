import 'package:flutter/material.dart';
import 'package:flutter_application/domain/control/controlAuth.dart';
import 'package:flutter_application/data/services/FirebaseData/Auth.dart';
import 'package:get/get.dart';

class ingreso extends StatefulWidget {
  const ingreso({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<ingreso> {
  final TextEditingController emailControl = TextEditingController();
  final TextEditingController passwControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ControlUserAuth cua = Get.find();
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
            Navigator.pushNamed(context, '/login');
          },
        ),
      ),

      backgroundColor:
          Color(0xFF0e0c19), // Establece el color de fondo del Scaffold
      body: SingleChildScrollView(
        // Para permitir el desplazamiento si el contenido excede el tamaño de la pantalla
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 80.0),
            CircleAvatar(
              radius: 130,
              backgroundImage: AssetImage('logo1.png'),
              backgroundColor: Colors
                  .transparent, // Hace que el color de fondo del CircleAvatar sea transparente
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Text(
              "Iniciar Sesion",
              style: TextStyle(
                color: Colors.white, // Color blanco
                fontWeight: FontWeight.bold, // Texto en negrita
                // Padding en la parte superior
              ),
            ),
            const SizedBox(height: 10.0, width: 400),
            Column(
              children: [
                SizedBox(height: 20),
                // Input 1: Correo electrónico
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Correo electrónico',
                    labelText: 'Email',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(151, 255, 255, 255),
                    ),
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
                  controller: emailControl,
                ),
                SizedBox(height: 20),
                // Input 2: Contraseña
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Contraseña',
                    labelText: 'Contraseña',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(151, 255, 255, 255),
                    ),
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
                  controller: passwControl,
                ),
                SizedBox(height: 20),
                // Input 3: Confirmar Contraseña
              ],
            ),
            const SizedBox(height: 30.0, width: 400),
            SizedBox(
              width: 280,
              height: 40, // Ancho deseado del botón
              child: ElevatedButton(
                onPressed: () {
                  cua
                      .ingresarUser(emailControl.text, passwControl.text)
                      .then((value) async {
                    if (cua.userValido == null) {
                      Get.snackbar(
                        'Título del Snackbar',
                        'Contenido del Snackbar',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.amber,
                        colorText: Colors.white,
                        borderRadius: 10,
                        margin: const EdgeInsets.all(10),
                        duration: const Duration(seconds: 3),
                        isDismissible: true,
                        dismissDirection: DismissDirection.vertical,
                        forwardAnimationCurve: Curves.easeOutBack,
                        reverseAnimationCurve: Curves.easeInBack,
                      );
                    } else {
                      dynamic resultado =
                          await cua.obtenerUser(emailControl.text);
                      if (resultado['rol'] == 'Driver') {
                        Get.toNamed('/homeConductores');
                        print('estos son los datos del login de');
                        print(resultado);
                      } else if (resultado['rol'] == 'Admin') {
                        Get.offAllNamed('/home');
                        print('estos son los datos del login de');
                        print(resultado);
                      }
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF775776),
                  side: BorderSide(
                    color: const Color(0xFF775776),
                    width: 2.0,
                  ),
                ),
                child: const Text(
                  "Iniciar Sesión",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30.0, width: 400),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
