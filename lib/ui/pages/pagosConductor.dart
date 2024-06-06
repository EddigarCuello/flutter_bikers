import 'package:flutter/material.dart';

class PagoConductor extends StatefulWidget {
  const PagoConductor({Key? key}) : super(key: key);

  @override
  _PagoConductorState createState() => _PagoConductorState();
}

class _PagoConductorState extends State<PagoConductor> {
  DateTime? _startDate;
  DateTime? _endDate;

  List<Map<String, String>> carreras = [
    {
      'fecha': '01/04/2024',
      'descripcion': 'Universidad a Don Alberto',
      'valor': '\$20000',
    },
    {
      'fecha': '01/04/2025',
      'descripcion': 'Universidad a Don Alberto',
      'valor': '\$20000',
    },
    // Agrega más elementos si es necesario
  ];

  List<Map<String, String>> filteredCarreras = [];

  @override
  void initState() {
    super.initState();
    filteredCarreras = List.from(carreras);
    _applyFilter();
  }

  void _applyFilter() {
    setState(() {
      filteredCarreras = carreras.where((carrera) {
        DateTime fecha = DateTime.parse(_reverseDateFormat(carrera['fecha']!));
        if (_startDate != null && fecha.isBefore(_startDate!)) return false;
        if (_endDate != null && fecha.isAfter(_endDate!)) return false;
        return true;
      }).toList();
    });
  }

  String _reverseDateFormat(String date) {
    List<String> parts = date.split('/');
    return '${parts[2]}-${parts[1]}-${parts[0]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0e0c19),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0e0c19),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF775776)), // Color de la flecha
          onPressed: () {
            Navigator.pushNamed(context, '/homeConductores'); // Redirige a la ruta /homeConductores
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filtro por fecha
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
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
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
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
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              child: Card(
                color: const Color(0xFF0e0c19),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(
                    color: Color.fromRGBO(26, 23, 41, 1),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: filteredCarreras
                        .map((carrera) => Container(
                              margin: EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(7.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color.fromRGBO(119, 87, 118, 1),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Fecha: ${carrera['fecha']}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Descripción: ${carrera['descripcion']}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Valor: ${carrera['valor']}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                // Input 1: Valor
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Valor',
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
                SizedBox(height: 10),
                // Input 2: Descripción (TextArea)
                Container(
                  constraints: BoxConstraints(maxHeight: 200),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Descripción',
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
                    maxLines: null,
                  ),
                ),
                SizedBox(height: 20),
                // Botones
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Acción para el botón "Agregar"
                      },
                      child: Text(
                        'Agregar',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(150, 50),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Acción para el botón "Eliminar"
                      },
                      child: Text(
                        'Eliminar',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(150, 50),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
