import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application/data/services/FirebaseData/MotoData.dart';
import 'package:flutter_application/data/services/FirebaseData/TimeData.dart';
import 'package:flutter_application/domain/modelos/horario.dart';
import 'package:get/get.dart';

class ControlTime extends GetxController {
  final _response = Rxn();
  final _emailLocal = Rxn();
  final _passwdLocal = Rxn();
  final _mensaje = "".obs;
  final Rxn<UserCredential> _usuario = Rxn<UserCredential>();

  Future<void> guardarHorario(Horario dtime) async {
    if (dtime.placa != null && dtime.kilometros != null) {
      print('aqui en guaradr hoario la placa es' + dtime.placa!);
      Map<String, dynamic>? motoData =
          await MotoData.findBikeBy('placa', dtime.placa!);

      String? kmString = motoData?['kilometraje'];
      print('aqui en guaradr hoario los klmt son' + kmString!);
      String? kmEntranteString = dtime.kilometros;

      double km = double.parse(kmString);
      double kmEntrante = double.parse(kmEntranteString!);

      double resultado = kmEntrante - km;
      dtime.kilometros = resultado.toString();
    } else {
      throw Exception('El valor o el valor entrante no pueden ser nulos');
    }

    _response.value = await TimeData.GuardarHorario(dtime);
    print(_response.value);
  }

  Future<List<Map<String, dynamic>>?> obtenerHorarios(String placa) async {
    try {
      List<Map<String, dynamic>>? horarios =
          await TimeData.findTimesBy('placa', placa);
      if (horarios == null || horarios.isEmpty) {
        print('No se encontraron horarios asociados a la placa $placa');
        return null;
      }
      return horarios;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> obtenerHorariosAdmin(
      String ccAdmin) async {
    try {
      List<Map<String, dynamic>>? motos =
          await MotoData.findBikesBy('cedula_admin', ccAdmin);
      if (motos == null || motos.isEmpty) {
        print('No se encontraron motos asociadas a la cedula $ccAdmin');
        return null;
      }

      List<Map<String, dynamic>> horarios = [];

      for (var moto in motos) {
        String placa = moto['placa'];
        List<Map<String, dynamic>>? horariosMoto =
            await TimeData.findTimesBy('placa', placa);

        if (horariosMoto != null && horariosMoto.isNotEmpty) {
          horarios.addAll(horariosMoto);
        }
      }

      if (horarios.isEmpty) {
        print(
            'No se encontraron horarios para las motos asociadas a la cedula $ccAdmin');
        return null;
      }

      return horarios;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Horario>?> obtenerHorariosFecha(String placa) async {
    try {
      List<Map<String, dynamic>>? horariosData =
          await TimeData.findTimesBy('placa', placa);

      if (horariosData == null || horariosData.isEmpty) {
        print('No se encontraron horarios asociados a la placa $placa');
        return null;
      }
      // Convertir los mapas a objetos Horario y filtrar los que tienen fechaCierre vacía
      List<Horario> horarios = horariosData
          .map((map) => Horario(
              placa: map['placa'] as String?,
              fechaInicio: map['fecha_inicio'] as String?,
              fechaCierre: map['fecha_cierre'] as String?,
              horaInicio: map['hora_inicio'] as String?,
              horaCierre: map['hora_cierre'] as String?,
              kilometros: map['kilometros'] as String?,
              valor: map['valor'] as String?))
          .where((horario) =>
              horario.fechaCierre == null || horario.fechaCierre!.isEmpty)
          .toList();

      return horarios;
    } catch (e) {
      print(e);
      return null;
    }
  }

  dynamic get passwdLocal => _passwdLocal.value;
  dynamic get emailLocal => _emailLocal.value;
  dynamic get estadoUser => _response.value;
  String get mensajesUser => _mensaje.value;
  UserCredential? get userValido => _usuario.value;
}
