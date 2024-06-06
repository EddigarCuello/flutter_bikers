import 'package:flutter/material.dart';

class EliminarEstudiante extends StatelessWidget {
  const EliminarEstudiante({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eliminar Estudiante'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Aquí puedes agregar la lógica para eliminar un estudiante
            // Por ejemplo, puedes llamar a una función en el controlador
            // EstudianteController para eliminar un estudiante.
          },
          child: Text('Eliminar Estudiante'),
        ),
      ),
    );
  }
}
