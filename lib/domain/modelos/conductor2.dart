import 'package:flutter/material.dart';

class Conductor {
  final String nombre;
  final String cedula;
  final String placa;
  String estado;
  int kilometraje;
  DateTime? fechaInicio;
  DateTime? fechaCierre;
  TimeOfDay? horaInicio;
  TimeOfDay? horaCierre;

  Conductor({
    required this.nombre,
    required this.cedula,
    required this.placa,
    required this.estado,
    required this.kilometraje,
    this.fechaInicio,
    this.fechaCierre,
    this.horaInicio,
    this.horaCierre,
  });

  factory Conductor.fromJson(Map<String, dynamic> json) {
    return Conductor(
      nombre: json['nombre'],
      cedula: json['cedula'],
      placa: json['placa'],
      estado: json['estado'],
      kilometraje: json['kilometraje'],
      fechaInicio: json.containsKey('fechaInicio')
          ? DateTime.parse(json['fechaInicio'])
          : null,
      fechaCierre: json.containsKey('fechaCierre')
          ? DateTime.parse(json['fechaCierre'])
          : null,
      horaInicio: json.containsKey('horaInicio')
          ? TimeOfDay(
              hour: int.parse(json['horaInicio'].split(":")[0]),
              minute: int.parse(json['horaInicio'].split(":")[1]),
            )
          : null,
      horaCierre: json.containsKey('horaCierre')
          ? TimeOfDay(
              hour: int.parse(json['horaCierre'].split(":")[0]),
              minute: int.parse(json['horaCierre'].split(":")[1]),
            )
          : null,
    );
  }

  set cuota(int cuota) {}

  @override
  String toString() {
    return 'Conductor{nombre: $nombre, cedula: $cedula, placa: $placa, estado: $estado, kilometraje: $kilometraje}';
  }
}

void eliminarEstudiante(
    List<Conductor> conductores, String nombre, String cedula) {
  conductores.removeWhere(
      (conductor) => conductor.nombre == nombre && conductor.cedula == cedula);
}

List<Map<String, dynamic>> listaJson = [
  {
    'nombre': 'Juan',
    'cedula': '124567890',
    'edad': 20,
    'placa': 'UCL8978',
    'estado': 'En Garaje',
    'kilometraje': 10000,
  },
  {
    'nombre': 'María',
    'cedula': '124567890',
    'edad': 21,
    'placa': 'UCL8958',
    'estado': 'En Garaje',
    'kilometraje': 15000,
  },
  {
    'nombre': 'Pedro',
    'cedula': '124567890',
    'edad': 22,
    'placa': 'UCL8928',
    'estado': 'En Garaje',
    'kilometraje': 20000,
  },
];

List<Conductor> estudiantesOriginal =
    listaJson.map((json) => Conductor.fromJson(json)).toList();
