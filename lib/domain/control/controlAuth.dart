import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application/data/services/FirebaseData/Auth.dart';
import 'package:flutter_application/domain/modelos/Persona.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ControlUserAuth extends GetxController {
  final _response = Rxn();
  final _emailLocal = Rxn();
  final _passwdLocal = Rxn();
  final _mensaje = "".obs;
  final Rxn<UserCredential> _usuario = Rxn<UserCredential>();

  Future<void> crearUser(Persona user) async {
    _response.value = await Peticioneslogin.crearRegistroEmail(user);
    _passwdLocal.value = user.password;
    print(_response.value);
    await controlUser(_response.value);
  }

  Future<void> ingresarUser(String email, String pass) async {
    _response.value = await Peticioneslogin.ingresarEmail(email, pass);
    _passwdLocal.value = pass;
    print(_response.value);
    await controlUser(_response.value);
  }

  Future<Map<String, dynamic>?> obtenerUser(String correo) async {
    try {
      // Obtener el conductor por cédula
      Map<String, dynamic>? conductor =
          await Peticioneslogin.findUserBy('email', correo);

      // Verificar si se encontró el conductor
      if (conductor != null) {
        return conductor;
      } else {
        // Lanzar una excepción si no se encontró el conductor
        throw Exception('Usuario no encontrado');
      }
    } catch (e) {
      // Manejar errores si es necesario
      print('Error al obtener el Usuario: $e');
      throw e; // Lanzar nuevamente la excepción para que el llamador la maneje
    }
  }

  Future<void> controlUser(dynamic respuesta) async {
    if (respuesta == null) {
      _mensaje.value = "No Se Completo la Consulta";
    } else if (respuesta == "1" || respuesta == "2") {
      _mensaje.value = "Datos Ingresas Incorrectos";
    } else {
      _mensaje.value = "Proceso Realizado Correctamente";
      _usuario.value = respuesta;

      guardaLocal();
    }
  }

  Future<void> guardaLocal() async {
    GetStorage datosLocal = GetStorage();
    datosLocal.write('email', _usuario.value!.user!.email);
    datosLocal.write('passwd', _passwdLocal.value);
  }

  Future<void> verLocal() async {
    GetStorage datosLocal = GetStorage();
    _emailLocal.value = datosLocal.read('email');
    _passwdLocal.value = datosLocal.read('passwd');
    print(_emailLocal.value);
  }

  dynamic get passwdLocal => _passwdLocal.value;
  dynamic get emailLocal => _emailLocal.value;
  dynamic get estadoUser => _response.value;
  String get mensajesUser => _mensaje.value;
  UserCredential? get userValido => _usuario.value;
}
