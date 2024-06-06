import 'package:flutter_application/domain/modelos/Persona.dart';

class Conductor extends Persona {
  String? excedente;
  String? cuota;
  String? placa;

  Conductor({
    this.placa,
    this.excedente,
    this.cuota,
    required super.cedula,
  });

  factory Conductor.fromJson(Map<String, dynamic> json) {
    return Conductor(
      cedula: json['cedula'],
      placa: json['placa'],
      excedente: json['excedente'],
      cuota: json['cuota'],
    );
  }

  @override
  String toString() {
    return 'Conductor{nombre: $nombre,apellido: $apellido,correo: $correo, cedula: $cedula, placa: $placa, excedente: $excedente, cuota: $cuota}';
  }
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
