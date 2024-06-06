class Cuenta {
  final String fecha;
  final String descripcion;
  final String valor;
  final String placa;

  Cuenta({
    required this.fecha,
    required this.descripcion,
    required this.valor,
    required this.placa,
  });

  factory Cuenta.fromJson(Map<String, dynamic> json) {
    return Cuenta(
      fecha: json['fecha'],
      descripcion: json['descripcion'],
      valor: json['valor'],
      placa: json['placa'],
    );
  }

  @override
  String toString() {
    return 'Conductor{fecha: $fecha , descripcion: $descripcion ,valor: $valor, placa: $placa}';
  }
}
