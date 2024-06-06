import 'package:flutter/material.dart';
import 'package:flutter_application/domain/control/ControlDriver.dart';
import 'package:flutter_application/domain/control/ControlTime.dart';
import 'package:flutter_application/domain/modelos/horario.dart';
import 'package:flutter_application/ui/pages/Motos/list.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    const ListaEstudiantes(),
    const Inicio(),
    const CallsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          _buildNavigationBarItem(
              Icons.person, "Registro", _selectedIndex == 0),
          _buildNavigationBarItem(
              Icons.electric_bike, "Motos", _selectedIndex == 1),
          _buildNavigationBarItem(
              Icons.file_copy, "Archivos", _selectedIndex == 2),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 0,
        backgroundColor: Color(0xFF0e0c19),
      ),
    );
  }
}

BottomNavigationBarItem _buildNavigationBarItem(
    IconData icon, String txtlabel, bool isActive) {
  return BottomNavigationBarItem(
    icon: Icon(
      icon,
      color: isActive ? const Color(0xFF775776) : Colors.grey,
    ),
    label: txtlabel,
  );
}

class Inicio extends StatelessWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'fondo.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 80,
            left: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Container(
                padding: EdgeInsets.all(8),
                color: Color(0xFF120f20),
                child: Text(
                  "Hola, papa dio insano",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.4,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Color(0xFF120f20),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: FutureBuilder<List<Map<String, dynamic>>?>(
                future: ControlDriver().DriverAndBike('1003380904'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData && snapshot.data != null) {
                    List<Map<String, dynamic>> motos = snapshot.data!;
                    // Filtrar la lista por el estado 'rodando'
                    motos = motos
                        .where((moto) => moto['estado'] == 'rodando')
                        .toList();

                    String titulo =
                        motos.isNotEmpty ? "Motos en uso" : "Iniciar día";

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            titulo,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6750a4),
                              fontSize: 40.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        if (motos.isNotEmpty)
                          Expanded(
                            child: ListView.builder(
                              itemCount: motos.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Card(
                                    color: Color(0xFF120f20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                        color: Color(0xFF775776),
                                      ),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        motos[index]['nombre'],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        motos[index]['placa'],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onTap: () {
                                        // Llamar al método para mostrar el popup
                                        _showUpdateKilometrajeDialog(
                                            context, motos[index]['placa']);
                                        // Llamar a obtenerHorariosFecha y printear el resultado
                                        obtenerHorariosFechaYMostrar(
                                            context, motos[index]['placa']);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        SizedBox(height: 20),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Get.toNamed('/apertura');
                              },
                              style: ElevatedButton.styleFrom(
                                side: BorderSide(
                                  color: const Color(0xFF775776),
                                  width: 2.0,
                                ),
                                backgroundColor: Color(0xFF0e0c19),
                              ),
                              child: const Text(
                                "Agregar Moto",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "Iniciar día",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6750a4),
                              fontSize: 40.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Get.toNamed('/apertura');
                              },
                              style: ElevatedButton.styleFrom(
                                side: BorderSide(
                                  color: const Color(0xFF775776),
                                  width: 2.0,
                                ),
                                backgroundColor: Color(0xFF0e0c19),
                              ),
                              child: const Text(
                                "Agregar Moto",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUpdateKilometrajeDialog(BuildContext context, String placa) {
    TextEditingController kilometrajeController = TextEditingController();
    TextEditingController cuotaController = TextEditingController();
    bool isCheckboxChecked = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Actualizar Kilometraje'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: kilometrajeController,
                    decoration: InputDecoration(
                      hintText: 'Ingrese el nuevo kilometraje',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                  CheckboxListTile(
                    title: Text('Cumplió con la cuota?'),
                    value: isCheckboxChecked,
                    onChanged: (bool? value) async {
                      isCheckboxChecked = value ?? false;
                      setState(() {
                        isCheckboxChecked = value ?? false;
                      });

                      if (isCheckboxChecked) {
                        // Si el checkbox está marcado, obtenemos automáticamente la cuota asociada a la placa
                        String? cuota = await _fetchCuota(placa, '1003380904');

                        print(cuota);
                        if (cuota != null) {
                          // Si se encuentra la cuota, actualizamos el texto del controlador con el valor de la cuota
                          cuotaController.text = cuota;
                        } else {
                          print('no hay cuota en la funcion');
                        }
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: cuotaController,
                    decoration: InputDecoration(
                      hintText: 'Ingrese la cuota',
                    ),
                    keyboardType: TextInputType.number,
                    enabled: !isCheckboxChecked,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    String nuevoKilometraje = kilometrajeController.text;
                    String cuota = cuotaController.text;
                    if (nuevoKilometraje.isNotEmpty) {
                      // Obtener el horario actual
                      List<Horario>? horarios =
                          await ControlTime().obtenerHorariosFecha(placa);
                      if (horarios != null && horarios.isNotEmpty) {
                        Horario horario = horarios.first;

                        // Calcular kilómetros recorridos
                        double kilometrosActuales =
                            double.parse(nuevoKilometraje);
                        double kilometrosIniciales =
                            double.parse(horario.kilometros ?? '0');
                        double kilometrosRecorridos =
                            kilometrosActuales - kilometrosIniciales;

                        // Actualizar horario con fecha y hora actuales
                        DateTime ahora = DateTime.now();
                        String fechaCierre =
                            "${ahora.year}-${ahora.month}-${ahora.day}";
                        String horaCierre =
                            "${ahora.hour}:${ahora.minute}:${ahora.second}";

                        // Crear nuevo horario con los datos actualizados
                        Horario horarioActualizado = Horario(
                          placa: horario.placa,
                          fechaInicio: horario.fechaInicio,
                          horaInicio: horario.horaInicio,
                          fechaCierre: fechaCierre,
                          horaCierre: horaCierre,
                          kilometros: kilometrosRecorridos.toString(),
                          valor: cuota,
                        );

                        // Guardar el nuevo horario
                        await ControlTime().guardarHorario(horarioActualizado);

                        // Actualizar el estado de la moto
                        await ControlDriver()
                            .cambiarKilometraje(placa, nuevoKilometraje);
                        await ControlDriver().cambiarEstado(placa, 'garaje');
                      }
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text('Actualizar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<String?> _fetchCuota(String placa, String cedulaAdmin) async {
    try {
      // Obtener el conductor y su bicicleta por cédula del administrador
      List<Map<String, dynamic>>? drivers =
          await ControlDriver().DriverAndBike(cedulaAdmin);
      print('los drivers');
      print(drivers);

      for (var driver in drivers!) {
        if (driver['placa'] == placa) {
          print('aqui en la funcion');
          print(driver);
          return driver['cuota'].toString();
        }
      }

      print('Dentro de la función no se encontró nada');

      return null;
    } catch (e) {
      print('Error al obtener la cuota: $e');
      throw e;
    }
  }

  void obtenerHorariosFechaYMostrar(BuildContext context, String placa) async {
    List<Horario>? horarios = await ControlTime().obtenerHorariosFecha(placa);
    if (horarios != null) {
      horarios.forEach((horario) {
        print('Horario: ${horario.fechaInicio} - ${horario.horaInicio}');
      });
    } else {
      print('No se encontraron horarios para la placa $placa');
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ganancias Mensuales',
      theme: ThemeData.dark(),
      home: CallsPage(),
    );
  }
}


class CallsPage extends StatefulWidget {
  const CallsPage({Key? key}) : super(key: key);

  @override
  _CallsPageState createState() => _CallsPageState();
}

class _CallsPageState extends State<CallsPage> {
  final ControlTime _controlTime = Get.put(ControlTime());
  late List<Map<String, dynamic>> horarios = [];
  late List<Map<String, dynamic>> filteredHorarios = [];
  String? selectedDate;
  double totalEarnings = 0.0;
  DateTime? fromDate;
  DateTime? toDate;

  @override
  void initState() {
    super.initState();
    _obtenerHorarios();
  }

  Future<void> _obtenerHorarios() async {
    try {
      List<Map<String, dynamic>>? horariosData =
          await _controlTime.obtenerHorariosAdmin('1003380904');

      if (horariosData != null && horariosData.isNotEmpty) {
        setState(() {
          horarios = horariosData;
          _filterHorarios();
        });

        for (var horario in horarios) {
          print('Placa: ${horario['placa']}');
          print('Fecha Inicio: ${horario['fecha_inicio']}');
          print('Hora Inicio: ${horario['hora_inicio']}');
          print('Fecha Cierre: ${horario['fecha_cierre']}');
          print('Hora Cierre: ${horario['hora_cierre']}');
          print('Kilometraje: ${horario['kilometros']}');
          print('Valor: ${horario['valor']}');
        }
      } else {
        print('No se encontraron horarios asociados a la cédula 1003380904');
      }
    } catch (e) {
      print('Error al obtener horarios: $e');
    }
  }

  void _filterHorarios() {
    setState(() {
      filteredHorarios = horarios.where((horario) {
        DateTime fechaInicio = DateTime.parse(horario['fecha_inicio']);
        if (fromDate != null && fechaInicio.isBefore(fromDate!)) {
          return false;
        }
        if (toDate != null && fechaInicio.isAfter(toDate!)) {
          return false;
        }
        return true;
      }).toList();
      totalEarnings = _calculateTotalEarnings(filteredHorarios);
    });
  }

  double _calculateTotalEarnings(List<Map<String, dynamic>> horarios) {
    return horarios.fold(0.0, (sum, horario) {
      double valor = double.tryParse(horario['valor'].toString()) ?? 0.0;
      return sum + valor;
    });
  }

  String formatDate(String dateTimeString) {
    try {
      DateTime dateTime = DateTime.parse(dateTimeString);
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fromDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != fromDate) {
      setState(() {
        fromDate = picked;
        _filterHorarios();
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: toDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != toDate) {
      setState(() {
        toDate = picked;
        _filterHorarios();
      });
    }
  }

  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
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
    return Scaffold(
      backgroundColor: const Color(0xFF120F20),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => _selectFromDate(context),
                    child: Text(
                      fromDate == null
                          ? 'Desde'
                          : DateFormat('yyyy-MM-dd').format(fromDate!),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C2943),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      textStyle: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectToDate(context),
                    child: Text(
                      toDate == null
                          ? 'Hasta'
                          : DateFormat('yyyy-MM-dd').format(toDate!),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C2943),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      textStyle: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Historial de Horarios",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.white,
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
                    color: const Color(0xFF1E1B30),
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
                              color: const Color(0xFF2C2943),
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
              const Text(
                "Ganancia Total",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromRGBO(119, 87, 118, 1),
                  ),
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xFF2C2943),
                ),
                child: Text(
                  'Total: $totalEarnings',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const Text(
                "Gráfica de Ganancia vs Tiempo",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              Container(
                height: 300,
                padding: const EdgeInsets.fromLTRB(
                    32.0, 16.0, 16.0, 16.0), // Add padding here
                child: BarChart(
                  BarChartData(
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
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
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
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        tooltipPadding: const EdgeInsets.all(8),
                        tooltipMargin: 8,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          String formattedDate = DateFormat('dd/MM/yyyy').format(
                            DateTime.fromMillisecondsSinceEpoch(group.x.toInt()),
                          );
                          return BarTooltipItem(
                            formattedDate,
                            const TextStyle(color: Colors.white),
                          );
                        },
                      ),
                      touchCallback: (FlTouchEvent event, barTouchResponse) {
                        if (barTouchResponse != null &&
                            barTouchResponse.spot != null) {
                          final spot = barTouchResponse.spot!;
                          setState(() {
                            selectedDate = DateFormat('dd/MM/yyyy').format(
                              DateTime.fromMillisecondsSinceEpoch(spot.touchedBarGroup.x.toInt()),
                            );
                          });
                        } else {
                          setState(() {
                            selectedDate = null;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
              if (selectedDate != null)
                Text(
                  'Fecha seleccionada: $selectedDate',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _showLogoutConfirmationDialog(),
                child: const Text('Cerrar Sesión'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C2943),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
