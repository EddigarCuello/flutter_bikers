import 'package:flutter/material.dart';
import 'package:flutter_application/domain/control/controlDriver.dart';
import 'package:flutter_application/domain/modelos/conductor.dart';
import 'package:flutter_application/domain/modelos/moto.dart';
import 'package:get/get.dart';

class AdicionarEstudiante extends StatelessWidget {
  AdicionarEstudiante({Key? key}) : super(key: key);

  final cedulaController =
      TextEditingController(); // Cambiado a cedulaController
  final cuotaController =
      TextEditingController(); // Nuevo controlador para Cuota
  final placaController = TextEditingController();
  final kilometrajeController =
      TextEditingController(); // Nuevo controlador para Kilometraje

  final ControlDriver _controlDriver = Get.find();

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
            Navigator.pushNamed(context, '/home');
          },
        ),
      ),
      backgroundColor: const Color(0xFF0e0c19),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 140.0),
            const Text(
              "Datos del conductor",
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: cedulaController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Cédula",
                labelStyle: const TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: cuotaController, // Nuevo controlador para Cuota
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Cuota", // Nuevo label para Cuota
                labelStyle: const TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              "Datos de la moto",
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: placaController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Placa",
                labelStyle: const TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller:
                  kilometrajeController, // Nuevo controlador para Kilometraje
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Kilometraje", // Nuevo label para Kilometraje
                labelStyle: const TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                final conductor = Conductor(
                  cedula: cedulaController.text, // Usando el cedulaController
                  placa: placaController.text,
                  cuota: cuotaController.text,
                );

                //llama la funcion nsegun cedulacontroer.text nnecesito el userId

                final moto = Moto(
                  ccAdmin: '1003380904', // Usando el cedulaController
                  ccConductor: cedulaController.text,
                  placa: placaController.text,
                  kilometraje: kilometrajeController.text,
                  estado: 'garaje',
                );

                String? userId =
                    await _controlDriver.obtenerUserId(cedulaController.text);

                _controlDriver.guardarCoductor(conductor, userId!, moto);

                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF775776),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                side: const BorderSide(
                    color: Color.fromARGB(0, 225, 218, 218), width: 2.0),
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 15.0),
              ),
              child: const Text(
                "Adicionar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
