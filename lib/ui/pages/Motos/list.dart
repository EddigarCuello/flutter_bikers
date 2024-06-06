import 'package:flutter/material.dart';
import 'package:flutter_application/domain/control/controlDriver.dart';
import 'package:get/get.dart';

class ListaEstudiantes extends StatelessWidget {
  const ListaEstudiantes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ControlDriver controlDriver =
        Get.find(); // Obtener una instancia de ControlDriver
    return Scaffold(
      backgroundColor: const Color(0xFF0e0c19),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>?>(
              future: controlDriver.DriverAndBike('1003380904'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error al cargar los datos',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No hay conductores',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                final data = snapshot.data!;

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 0, // Sin elevación
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      color: const Color(0xFF0e0c19), // Color de fondo
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Color(0xFF775776)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFF775776),
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(
                          data[index]['nombre'] ?? 'Nombre no disponible',
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          data[index]['placa'] ?? 'Placa no disponible',
                          style: const TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Get.toNamed('/conductor_data',
                              arguments: data[index]);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(
                    '/addEstudiante'); // Cambiar esta ruta si es necesario
              },
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: const Color(0xFF775776), width: 2.0),
              ),
              child: const Text(
                "Agregar Moto",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
