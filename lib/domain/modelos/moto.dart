class Moto {
  final String placa;
  final String kilometraje;
  String? estado;
  final String ccAdmin;
  final String ccConductor;

  Moto({
    required this.kilometraje,
    this.estado,
    required this.ccAdmin,
    required this.ccConductor,
    required this.placa,
  });

  factory Moto.fromJson(Map<String, dynamic> json) {
    return Moto(
      kilometraje: json['kilometraje'],
      estado: json['estado'],
      ccAdmin: json['ccAdmin'],
      ccConductor: json['ccConductor'],
      placa: json['placa'],
    );
  }

  @override
  String toString() {
    return 'Conductor{kilometraje: $kilometraje,estado: $estado,cedula Admin: $ccAdmin, cedula Conductor: $ccConductor, placa: $placa}';
  }
}
