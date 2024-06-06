import 'package:flutter/material.dart';
import 'package:get/get.dart'; // For input formatting (optional)
import 'package:intl/intl.dart'; // Import the intl package for date formatting

class Registro extends StatefulWidget {
  const Registro({Key? key}) : super(key: key);

  @override
  RegistroPageState createState() => RegistroPageState();
}

class RegistroPageState extends State<Registro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        // Make the content occupy the full available space
        child: Container(
          padding: const EdgeInsets.only(top: 70.0),
          height: double.infinity, // This makes the body occupy the full screen height
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
                  fit: BoxFit.contain, // Ajuste de la imagen dentro del contenedor
                ),
                const SizedBox(height: 50.0, width: 400),
                const SizedBox(height: 30.0, width: 400),
                const SizedBox(height: 30.0, width: 400),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Alinea los botones al centro horizontalmente
                  children: [
                    SizedBox(
                      width: 140, // Ancho deseado del primer botón
                      height: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.toNamed('/registroAdministrador');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0e0c19),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: const BorderSide(color: Color(0xFF775776), width: 2.0),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.person,
                              size: 90, // Tamaño del icono
                            ), // Agrega el icono de persona
                            SizedBox(height: 4), // Espacio entre el icono y el texto
                            Text(
                              "Administrador",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20), // Espacio entre los botones
                    SizedBox(
                      width: 140, // Ancho deseado del primer botón
                      height: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.toNamed('/registroConductor');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0e0c19),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: const BorderSide(color: Color(0xFF775776), width: 2.0),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.directions_bike,
                              size: 90, // Tamaño del icono
                            ), // Agrega el icono de persona
                            SizedBox(height: 4), // Espacio entre el icono y el texto
                            Text(
                              "Conductor",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: 140, // Ancho deseado del botón "Volver"
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0e0c19),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(color: Color(0xFF775776), width: 2.0),
                      ),
                    ),
                    child: const Text(
                      "Volver",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
