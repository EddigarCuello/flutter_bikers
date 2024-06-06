import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application/domain/modelos/conductor.dart';

class DriverData {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<dynamic> asignarMotoConductor(Conductor user, userId) async {
    Map<String, dynamic> userRolAccess = {};
    try {
      // Actualizar los campos en un documento existente en lugar de crear uno nuevo
      userRolAccess['cuota'] = user.cuota;
      userRolAccess['placa'] = user.placa;
      // Actualizar el documento en Firebase Database
      await _db.collection('User_Access').doc(userId).update(userRolAccess);

      // Puedes devolver algún tipo de confirmación si lo necesitas
      return 'Documento actualizado exitosamente';
    } catch (e) {
      print(e);
      // Manejo de errores si es necesario
      return null;
    }
  }

  static Future<dynamic> ingresarEmail(dynamic email, dynamic pass) async {
    try {
      // Iniciar sesión con correo electrónico y contraseña
      UserCredential usuario =
          await auth.signInWithEmailAndPassword(email: email, password: pass);

      return usuario;
    } on FirebaseAuthException catch (e) {
      // Manejar excepciones de Firebase Authentication
      if (e.code == 'user-not-found') {
        print('Correo no encontrado');
        return '1';
      } else if (e.code == 'wrong-password') {
        print('Contraseña incorrecta');
        return '2';
      } else {
        print('Error al iniciar sesión: ${e.message}');
        return null; // Otra forma de manejar otros errores
      }
    } catch (e) {
      // Manejar otras excepciones
      print('Error al iniciar sesión: $e');
      return null; // Otra forma de manejar otros errores
    }
  }

  static Future<String?> obtenerUserIdPorCedula(String cedula) async {
    try {
      // Realizar una consulta para obtener el documento correspondiente a la cédula
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('User_Access')
          .where('cedula', isEqualTo: cedula)
          .get();

      // Verificar si se encontró algún documento
      if (querySnapshot.docs.isNotEmpty) {
        // Tomar el primer documento encontrado
        DocumentSnapshot<Map<String, dynamic>> userData =
            querySnapshot.docs.first;

        // Obtener el ID único del usuario
        String userId = userData.id;
        print('ID del usuario: $userId');
        return userId;
      } else {
        // Si no se encontró ningún documento para la cédula dada
        print('Documento no encontrado para el usuario con cédula $cedula');
        return null;
      }
    } catch (e) {
      // Manejar excepciones
      print('Error al obtener el ID del usuario: $e');
      return null; // Otra forma de manejar otros errores
    }
  }

  static Future<Map<String, dynamic>?> findDriverBy(
      String campo, String valor) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('User_Access')
          .where(campo, isEqualTo: valor)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> userData =
            querySnapshot.docs.first;
        Map<String, dynamic> conductorData = userData.data()!;
        print('Datos del conductor: $conductorData');
        return conductorData;
      } else {
        print('Documento no encontrado para el campo $campo con valor $valor');
        return null;
      }
    } catch (e) {
      print('Error al obtener el conductor por $campo: $e');
      return null;
    }
  }
}
