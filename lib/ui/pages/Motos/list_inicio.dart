import 'package:flutter/material.dart';
import 'package:flutter_application/data/services/FirebaseData/TimeData.dart'; // Importar TimeData
import 'package:flutter_application/domain/control/controlDriver.dart';
import 'package:flutter_application/domain/modelos/horario.dart'; // Importar Horario
import 'package:get/get.dart';

class ListaMotos extends StatelessWidget {
  const ListaMotos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ControlDriver controlDriver =
        Get.find(); // Obtener una instancia de ControlDriver

    return Scaffold(
      backgroundColor: const Color(0xFF0e0c19),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0e0c19),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF6750a4),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>?>(
              future: controlDriver.DriverAndBike(
                  controlDriver.userValido?.user?.uid ?? '1003380904'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Error al cargar los datos',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay conductores',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                // Filtrar solo las motos con estado "garaje"
                final data = snapshot.data!
                    .where((moto) => moto['estado'] == 'garaje')
                    .toList();

                if (data.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay motos en el garaje',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      color: const Color(0xFF0e0c19),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Color(0xFF775776)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFF775776),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          data[index]['nombre'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          data[index]['placa'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Cambiar estado'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          final String placa =
                                              data[index]['placa'];
                                          final DateTime ahora = DateTime.now();

                                          // Convertir DateTime a String
                                          final String fechaInicio =
                                              ahora.toIso8601String();
                                          final String horaInicio =
                                              ahora.toIso8601String();

                                          // Crear instancia de Horario
                                          Horario nuevoHorario = Horario(
                                            placa: placa,
                                            fechaInicio: fechaInicio,
                                            horaInicio: horaInicio,
                                          );

                                          // Guardar horario usando TimeData
                                          var resultado =
                                              await TimeData.GuardarHorario(
                                                  nuevoHorario);
                                          print(resultado);

                                          // Llamar a cambiarEstado en la instancia de ControlDriver
                                          await controlDriver.cambiarEstado(
                                              placa, 'rodando');

                                          Navigator.pop(context);
                                          // Refrescar la lista después de actualizar el estado
                                          (context as Element).reassemble();
                                        },
                                        child: const Text('Rodando'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Acción para "En Taller"
                                          Navigator.pop(context);
                                        },
                                        child: const Text('En Taller'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
