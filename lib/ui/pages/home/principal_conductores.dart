import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fl_chart/fl_chart.dart'; // Asegúrate de agregar fl_chart en pubspec.yaml
import 'package:intl/intl.dart'; // Import the intl package

class HomeConductores extends StatefulWidget {
  const HomeConductores({Key? key}) : super(key: key);

  @override
  _HomeConductoresState createState() => _HomeConductoresState();
}

class _HomeConductoresState extends State<HomeConductores> {
  double progressValue = 0; // Variable para el valor de progreso
  double meta = 1000; // Meta
  double cuotaActual = 500; // Cuota actual

  // Lista de carreras
  final List<Map<String, dynamic>> carreras = [
    {'fecha': '2023-05-20', 'ganancia': 200},
    {'fecha': '2023-05-21', 'ganancia': 150},
    {'fecha': '2023-05-22', 'ganancia': 300},
    {'fecha': '2021-05-23', 'ganancia': 250},
    {'fecha': '2025-05-24', 'ganancia': 100},
  ];

  DateTime? startDate;
  DateTime? endDate;

  // Función para obtener las ganancias por fecha
  Map<String, double> obtenerGananciasPorFecha() {
    Map<String, double> gananciasPorFecha = {};
    for (var carrera in carreras) {
      String fecha = carrera['fecha'];
      double ganancia = carrera['ganancia'].toDouble();
      if (gananciasPorFecha.containsKey(fecha)) {
        gananciasPorFecha[fecha] = gananciasPorFecha[fecha]! + ganancia;
      } else {
        gananciasPorFecha[fecha] = ganancia;
      }
    }
    return gananciasPorFecha;
  }

  // Función para filtrar las ganancias por fecha
  Map<String, double> filtrarGananciasPorFecha(
      DateTime startDate, DateTime endDate) {
    Map<String, double> gananciasFiltradas = {};
    Map<String, double> gananciasPorFecha = obtenerGananciasPorFecha();
    gananciasPorFecha.forEach((fecha, ganancia) {
      DateTime date = DateTime.parse(fecha);
      if (date.isAfter(startDate.subtract(const Duration(days: 1))) &&
          date.isBefore(endDate.add(const Duration(days: 1)))) {
        gananciasFiltradas[fecha] = ganancia;
      }
    });
    return gananciasFiltradas;
  }

  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación de Cierre de Sesión'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Estás seguro de que quieres cerrar sesión?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/ingreso');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calcular el progreso hacia la meta
    progressValue = cuotaActual / meta;

    // Obtener todas las ganancias por fecha sin filtrar
    Map<String, double> gananciasPorFecha = obtenerGananciasPorFecha();

    // Si se seleccionan fechas de inicio y fin, filtrar las ganancias
    if (startDate != null && endDate != null) {
      gananciasPorFecha = filtrarGananciasPorFecha(startDate!, endDate!);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0e0c19), // Fondo de color
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != startDate) {
                        setState(() {
                          startDate = picked;
                        });
                      }
                    },
                    child: Text(startDate == null
                        ? 'Select Start Date'
                        : DateFormat('yyyy-MM-dd').format(startDate!)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != endDate) {
                        setState(() {
                          endDate = picked;
                        });
                      }
                    },
                    child: Text(endDate == null
                        ? 'Select End Date'
                        : DateFormat('yyyy-MM-dd').format(endDate!)),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              // Cuadro más grande
              Container(
                width: double.infinity,
                height: 500,
                decoration: BoxDecoration(
                  color: const Color(0xFF1a1729),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: const Color(0xFF775776),
                    width: 2.0,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    // Gráfico de barras
                    SizedBox(
                      width: 350,
                      height: 300,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          barGroups: gananciasPorFecha.entries
                              .map((entry) => BarChartGroupData(
                                    x: DateTime.parse(entry.key)
                                        .millisecondsSinceEpoch,
                                    barRods: [
                                      BarChartRodData(
                                        fromY: 0,
                                        toY: entry.value,
                                        color: Colors.lightBlueAccent,
                                      ),
                                    ],
                                  ))
                              .toList(),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  DateTime date =
                                      DateTime.fromMillisecondsSinceEpoch(
                                          value.toInt());
                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: Text(
                                      DateFormat('MM/dd').format(date),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 250,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0f0d1b),
                        borderRadius:
                            BorderRadius.circular(12.0), // Bordes redondos
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Cuota actual: \$${cuotaActual.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                  height: 20.0), // Espacio entre el cuadro y los botones
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 0),
                  SizedBox(
                    width: 180,
                    height: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        launch(
                            'https://www.runt.gov.co/consultaCiudadana/#/consultaVehiculo');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero, // Padding establecido en cero
                        backgroundColor: const Color(0xFF0e0c19),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: const BorderSide(
                              color: Color(0xFF775776), width: 2.0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "R", // Carácter correspondiente a "R" en Material Icons
                            style: TextStyle(
                              fontSize: 70,
                              color: Color(0xFF775776),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Documentos",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20), // Espacio entre los botones
                  SizedBox(
                    width: 180,
                    height: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/codigo');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0e0c19),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: const BorderSide(
                              color: Color(0xFF775776), width: 2.0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.book,
                            size: 60,
                            color: Color(0xFF775776),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: EdgeInsets.only(left: 3.0),
                            child: Text(
                              "Código de transporte",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _showLogoutConfirmationDialog(),
                child: const Text('Cerrar Sesión'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C2943),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  textStyle: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
