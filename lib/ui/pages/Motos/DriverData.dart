import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application/data/services/FirebaseData/TimeData.dart';

class ConductorData extends StatefulWidget {
  const ConductorData({Key? key}) : super(key: key);

  @override
  _ConductorDataState createState() => _ConductorDataState();
}

class _ConductorDataState extends State<ConductorData> {
  DateTime? _startDate;
  DateTime? _endDate;
  late List<Map<String, dynamic>> horarios;
  late List<Map<String, dynamic>> filteredHorarios;
  int? _selectedKilometrosIndex;
  int? _selectedGananciaIndex;

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  final DateFormat _timeFormat = DateFormat('HH:mm:ss');

  @override
  void initState() {
    super.initState();
    horarios = [];
    filteredHorarios = List.from(horarios);

    // Llama a la función para obtener horarios
    _obtenerHorarios();
  }

  Future<void> _obtenerHorarios() async {
    try {
      // Reemplaza 'placa' con el valor real de la placa que quieres consultar
      String placa = Get.arguments['placa'];
      List<Map<String, dynamic>>? horariosData =
          await TimeData.findTimesBy('placa', placa);

      if (horariosData != null && horariosData.isNotEmpty) {
        setState(() {
          horarios = horariosData;
          filteredHorarios = List.from(horarios);

          // Imprimir datos en consola
          for (var horario in horarios) {
            print('Placa: ${horario['placa']}');
            print('Fecha Inicio: ${horario['fecha_inicio']}');
            print('Hora Inicio: ${horario['hora_inicio']}');
            print('Fecha Cierre: ${horario['fecha_cierre']}');
            print('Hora Cierre: ${horario['hora_cierre']}');
            print('Kilometraje: ${horario['kilometros']}');
            print('Valor: ${horario['valor']}');
          }
        });
      } else {
        print('No se encontraron horarios asociados a la placa $placa');
      }
    } catch (e) {
      print('Error al obtener horarios: $e');
    }
  }

  String formatDate(String dateTimeString) {
    try {
      DateTime dateTime = DateTime.parse(dateTimeString);
      return _dateFormat.format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }

  String formatTime(String dateTimeString) {
    try {
      DateTime dateTime = DateTime.parse(dateTimeString);
      return _timeFormat.format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }

  Map<String, double> calculateSummary() {
    double totalGanancia = 0.0;
    double totalKilometros = 0.0;

    for (var horario in filteredHorarios) {
      totalGanancia += double.tryParse(horario['valor'].toString()) ?? 0.0;
      totalKilometros +=
          double.tryParse(horario['kilometros'].toString()) ?? 0.0;
    }

    double gananciaPorKilometro =
        totalKilometros != 0 ? totalGanancia / totalKilometros : 0.0;

    return {
      'totalGanancia': totalGanancia,
      'totalKilometros': totalKilometros,
      'gananciaPorKilometro': gananciaPorKilometro,
    };
  }

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map<String, dynamic>;
    Map<String, double> summary = calculateSummary();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0e0c19),
        elevation: 0,
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
      backgroundColor: const Color(0xFF0e0c19),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                    maxHeight: 200,
                  ),
                  child: Card(
                    color: const Color(0xFF0e0c19),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(
                        color: Color.fromRGBO(26, 23, 41, 1),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sin Multas',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: _startDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            _startDate = selectedDate;
                            _applyFilter();
                          });
                        }
                      },
                      child: Text(
                        _startDate == null
                            ? 'Desde'
                            : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: _endDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            _endDate = selectedDate;
                            _applyFilter();
                          });
                        }
                      },
                      child: Text(
                        _endDate == null
                            ? 'Hasta'
                            : '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _applyFilter();
                        });
                      },
                      child: const Text(
                        'Aplicar',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(),
                    ),
                  ],
                ),
              ),
              const Text(
                "Historial de Horarios",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6750a4),
                  fontSize: 20.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                    maxHeight: 400,
                  ),
                  child: Card(
                    color: const Color(0xFF0e0c19),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(
                        color: Color.fromRGBO(26, 23, 41, 1),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ListView.builder(
                        itemCount: filteredHorarios.length,
                        itemBuilder: (context, index) {
                          final horario = filteredHorarios[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(7.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromRGBO(119, 87, 118, 1),
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Placa: ${horario['placa']}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Fecha Inicio: ${formatDate(horario['fecha_inicio'])}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Hora Inicio: ${formatTime(horario['hora_inicio'])}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Fecha Cierre: ${formatDate(horario['fecha_cierre'])}',
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Hora Cierre: ${formatTime(horario['hora_cierre'])}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Kilometraje: ${horario['kilometros']}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Valor: ${horario['valor']}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Card(
                color: const Color(0xFF0e0c19),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: const BorderSide(
                    color: Color.fromRGBO(26, 23, 41, 1),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ganancia Total: ${summary['totalGanancia']}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Kilometraje Total: ${summary['totalKilometros']}',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Ganancia por Kilómetro: ${summary['gananciaPorKilometro']?.toStringAsFixed(4)}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Text(
                "Gráfica de Kilómetros vs Tiempo",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6750a4),
                  fontSize: 20.0,
                ),
              ),
              Container(
                height: 300,
                padding: const EdgeInsets.fromLTRB(
                    32.0, 16.0, 16.0, 16.0), // Add padding here
                child: BarChart(
                  BarChartData(
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                      ),
                      touchCallback: (event, response) {
                        if (response != null && response.spot != null) {
                          setState(() {
                            _selectedKilometrosIndex =
                                response.spot!.touchedBarGroupIndex;
                          });
                        }
                      },
                    ),
                    gridData: const FlGridData(show: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 5000,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toString(),
                              style: const TextStyle(color: Colors.white),
                            );
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    barGroups: filteredHorarios.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, dynamic> horario = entry.value;
                      DateTime fecha = DateTime.parse(horario['fecha_inicio']);
                      double kilometros =
                          double.tryParse(horario['kilometros'].toString()) ??
                              0.0;
                      return BarChartGroupData(
                        x: fecha.millisecondsSinceEpoch,
                        barRods: [
                          BarChartRodData(
                            toY: kilometros,
                            color: Colors.blue,
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
              if (_selectedKilometrosIndex != null)
                Text(
                  'Fecha: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(filteredHorarios[_selectedKilometrosIndex!]['fecha_inicio']))}',
                  style: const TextStyle(color: Colors.white),
                ),
              const Text(
                "Gráfica de Ganancia vs Tiempo",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6750a4),
                  fontSize: 20.0,
                ),
              ),
              Container(
                height: 300,
                padding: const EdgeInsets.fromLTRB(
                    32.0, 16.0, 16.0, 16.0), // Add padding here
                child: BarChart(
                  BarChartData(
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                      ),
                      touchCallback: (event, response) {
                        if (response != null && response.spot != null) {
                          setState(() {
                            _selectedGananciaIndex =
                                response.spot!.touchedBarGroupIndex;
                          });
                        }
                      },
                    ),
                    gridData: const FlGridData(show: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 500,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toString(),
                              style: const TextStyle(color: Colors.white),
                            );
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles:
                            SideTitles(reservedSize: 44, showTitles: true),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    barGroups: filteredHorarios.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, dynamic> horario = entry.value;
                      DateTime fecha = DateTime.parse(horario['fecha_inicio']);
                      double valor =
                          double.tryParse(horario['valor'].toString()) ?? 0.0;
                      return BarChartGroupData(
                        x: fecha.millisecondsSinceEpoch,
                        barRods: [
                          BarChartRodData(
                            toY: valor,
                            color: Colors.green,
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
              if (_selectedGananciaIndex != null)
                Text(
                  'Fecha: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(filteredHorarios[_selectedGananciaIndex!]['fecha_inicio']))}',
                  style: const TextStyle(color: Colors.white),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _applyFilter() {
    if (_startDate != null && _endDate != null) {
      DateTime startDate = _startDate!;
      DateTime endDate = _endDate!;

      filteredHorarios = horarios.where((horario) {
        DateTime fechaInicio = DateTime.parse(horario['fecha_inicio']);
        return fechaInicio.isAfter(startDate) && fechaInicio.isBefore(endDate);
      }).toList();

      setState(() {
        // Trigger UI update
      });
    }
  }
}
