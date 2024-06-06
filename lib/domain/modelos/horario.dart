class Horario {
  String? placa;
  String? fechaInicio;
  String? fechaCierre;
  String? horaInicio;
  String? horaCierre;
  String? kilometros;
  String? valor;

  Horario({
    this.placa,
    this.fechaInicio,
    this.fechaCierre,
    this.horaInicio,
    this.horaCierre,
    this.kilometros,
    this.valor,
  });

  factory Horario.fromJson(Map<String, dynamic> json) {
    return Horario(
      placa: json['placa'],
      fechaInicio: json['fechaCierre'],
      fechaCierre: json['fechaInicio'],
      horaInicio: json['horaInicio'],
      horaCierre: json['horaCierre'],
      kilometros: json['kilometros'],
      valor: json['valor'],
    );
  }

  @override
  String toString() {
    return 'Conductor{placa: $placa ,fechaInicio: $fechaInicio,fechaCierre: $fechaCierre,hora de inicio: $horaInicio, hora de cierre: $horaCierre ,kilometros: $kilometros, valor: $valor}';
  }
}
