import 'package:flutter/material.dart';
import 'package:flutter_application/domain/modelos/conductor2.dart';
import 'package:get/get.dart';

class EstudianteController extends GetxController {
  final _listaEstudiantes = <Conductor>[].obs;
  final _rodandoLista = <Conductor>[].obs;
  final _tallerLista = <Conductor>[].obs;
  final _horarios =
      <Map<String, dynamic>>[].obs; // Lista para almacenar los horarios

  @override
  void onInit() {
    super.onInit();
    _cargarEstudiantes();
  }

  void _cargarEstudiantes() async {
    _listaEstudiantes.value = estudiantesOriginal;
  }

  void guardarEstudiante(Conductor est) {
    _listaEstudiantes.add(est);
  }

  void eliminarEstudiante(Conductor estudiante) {
    _listaEstudiantes.remove(estudiante);
  }

  void cambiarEstado(Conductor estudiante, String nuevoEstado) {
    if (nuevoEstado == 'Rodando') {
      if (!_rodandoLista.contains(estudiante)) {
        estudiante.fechaInicio = DateTime.now();
        estudiante.horaInicio = TimeOfDay.now();
        _rodandoLista.add(estudiante);
      } else {
        print("El estudiante ya está en la lista rodando.");
      }
    } else if (nuevoEstado == 'En Garaje') {
      estudiante.fechaCierre = DateTime.now();
      estudiante.horaCierre = TimeOfDay.now();
      _tallerLista.add(estudiante);
      _guardarHorario(
          estudiante); // Guardar el horario al cambiar a "En Garaje"
    }
  }

  void _guardarHorario(Conductor estudiante) {
    _horarios.add({
      'placa': estudiante.placa,
      'fechaInicio': estudiante.fechaInicio,
      'horaInicio': estudiante.horaInicio,
      'fechaCierre': estudiante.fechaCierre,
      'horaCierre': estudiante.horaCierre,
      'kilometraje': estudiante.kilometraje,
    });
  }

  void printListaRodando() {
    print("Personas en la lista rodando:");
    _rodandoLista.forEach((conductor) {
      print("Nombre: ${conductor.nombre}, Placa: ${conductor.placa}");
    });
  }

  List<Conductor> get totalLista => _listaEstudiantes;
  List<Conductor> get rodandoLista => _rodandoLista;
  List<Conductor> get tallerLista => _tallerLista;
}
