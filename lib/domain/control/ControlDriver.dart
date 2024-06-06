import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application/data/services/FirebaseData/DriverData.dart';
import 'package:flutter_application/data/services/FirebaseData/MotoData.dart';
import 'package:flutter_application/domain/modelos/conductor.dart';
import 'package:flutter_application/domain/modelos/moto.dart';
import 'package:get/get.dart';

class ControlDriver extends GetxController {
  final _response = Rxn();
  final _emailLocal = Rxn();
  final _passwdLocal = Rxn();
  final _mensaje = "".obs;
  final Rxn<UserCredential> _usuario = Rxn<UserCredential>();

  Future<void> guardarCoductor(
      Conductor driver, String userId, Moto bike) async {
    _response.value = await DriverData.asignarMotoConductor(driver, userId);
    _response.value = await MotoData.GuardarMoto(bike);
    print(_response.value);
  }

  Future<void> cambiarEstado(String placa, String estado) async {
    _response.value = await MotoData.CambiarEstado(placa, estado);
    print(_response.value);
  }

  Future<void> cambiarKilometraje(String placa, String kilometraje) async {
    _response.value = await MotoData.CambiarKilometraje(placa, kilometraje);
    print(_response.value);
  }

  Future<List<Map<String, dynamic>>?> DriverAndBike(String ccAdmin) async {
    try {
      // Obtener todas las motos asociadas a la cédula del administrador
      List<Map<String, dynamic>>? motos =
          await MotoData.findBikesBy('cedula_admin', ccAdmin);
      if (motos == null || motos.isEmpty) {
        print(
            'No se encontraron motos para el administrador con cédula $ccAdmin');
        return null;
      }

      List<Map<String, dynamic>> resultado = [];
      for (var moto in motos) {
        String placa = moto['placa'];
        Map<String, dynamic>? conductor =
            await DriverData.findDriverBy('placa', placa);
        if (conductor != null) {
          resultado.add({
            'placa': placa,
            'nombre': conductor['nombre'],
            'cedula': conductor['cedula'],
            'estado': moto['estado'],
            'cuota': conductor['cuota'],
            // Ajusta este campo según tus datos
          });
        }
      }

      print('Resultado: $resultado');
      print('Resultado: $motos');
      return resultado;
    } catch (e) {
      print('Error al obtener las motos y conductores: $e');
      return null;
    }
  }

  Future<String?> obtenerUserId(String cedula) async {
    try {
      // Obtener el userId por cédula
      String? userId = await DriverData.obtenerUserIdPorCedula(cedula);

      // Devolver el userId obtenido
      return userId;
    } catch (e) {
      // Manejar errores si es necesario
      print('Error al obtener el userId: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> obtenerDriver(String cedula) async {
    try {
      // Obtener el conductor por cédula
      Map<String, dynamic>? conductor =
          await DriverData.findDriverBy('cedula', cedula);

      // Verificar si se encontró el conductor
      if (conductor != null) {
        return conductor;
      } else {
        // Lanzar una excepción si no se encontró el conductor
        throw Exception('Conductor no encontrado');
      }
    } catch (e) {
      // Manejar errores si es necesario
      print('Error al obtener el conductor: $e');
      throw e; // Lanzar nuevamente la excepción para que el llamador la maneje
    }
  }

  Future<Map<String, dynamic>?> obtenerDriverByPlaca(String placa) async {
    try {
      // Obtener el conductor por cédula
      Map<String, dynamic>? conductor =
          await DriverData.findDriverBy('placa', placa);

      // Verificar si se encontró el conductor
      if (conductor != null) {
        return conductor;
      } else {
        // Lanzar una excepción si no se encontró el conductor
        throw Exception('Conductor no encontrado');
      }
    } catch (e) {
      // Manejar errores si es necesario
      print('Error al obtener el conductor: $e');
      throw e; // Lanzar nuevamente la excepción para que el llamador la maneje
    }
  }

  dynamic get passwdLocal => _passwdLocal.value;
  dynamic get emailLocal => _emailLocal.value;
  dynamic get estadoUser => _response.value;
  String get mensajesUser => _mensaje.value;
  UserCredential? get userValido => _usuario.value;
}
