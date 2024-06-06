import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application/domain/modelos/Persona.dart';

class Peticioneslogin {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<dynamic> crearRegistroEmail(Persona user) async {
    Map<String, dynamic> userRolAccess = {};
    try {
      UserCredential usuario = await auth.createUserWithEmailAndPassword(
          email: user.correo!, password: user.password!);

      print("funcion " + usuario.toString());

      // Obtener el ID único del usuario registrado
      String userId = usuario.user!.uid;

      // Actualizar el campo 'uid' en los datos a guardar
      userRolAccess['uid'] = userId;
      userRolAccess['rol'] = user.rol;
      userRolAccess['email'] = user.correo;
      userRolAccess['nombre'] = user.nombre;
      userRolAccess['apellido'] = user.apellido;
      userRolAccess['cedula'] = user.cedula;

      // Guardar los datos en Firebase Database
      await _db.collection('User_Access').doc(userId).set(userRolAccess);

      return usuario;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Contraseña Debil');
        return '1';
      } else if (e.code == 'email-already-in-use') {
        print('Correo ya Existe');
        return '2';
      }
    } catch (e) {
      print(e);
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

  static Future<Map<String, dynamic>?> findUserBy(
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

  static Future<String?> obtenerRolUsuario(String email) async {
    try {
      // Realizar una consulta para obtener el documento correspondiente al correo electrónico
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('User_Access')
          .where('email', isEqualTo: email)
          .get();

      // Verificar si se encontró algún documento
      if (querySnapshot.docs.isNotEmpty) {
        // Tomar el primer documento encontrado
        DocumentSnapshot<Map<String, dynamic>> userData =
            querySnapshot.docs.first;

        // Verificar si el documento contiene el campo 'rol'
        if (userData.data()!.containsKey('rol')) {
          String rol = userData.data()!['rol'];
          print('Rol del usuario: -$rol');
          return rol;
        } else {
          // Si el documento no tiene el campo 'rol'
          print(
              'Rol no encontrado en el documento del usuario con correo $email');
          return null;
        }
      } else {
        // Si no se encontró ningún documento para el correo electrónico dado
        print('Documento no encontrado para el usuario con correo $email');
        return null;
      }
    } catch (e) {
      // Manejar excepciones
      print('Error al obtener el rol del usuario: $e');
      return null; // Otra forma de manejar otros errores
    }
  }

  static Future<String?> obtenerCedulaUsuario(String email) async {
    try {
      // Realizar una consulta para obtener el documento correspondiente al correo electrónico
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('User_Access')
          .where('email', isEqualTo: email)
          .get();

      // Verificar si se encontró algún documento
      if (querySnapshot.docs.isNotEmpty) {
        // Tomar el primer documento encontrado
        DocumentSnapshot<Map<String, dynamic>> userData =
            querySnapshot.docs.first;

        // Verificar si el documento contiene el campo 'cedula'
        if (userData.data()!.containsKey('cedula')) {
          String cedula = userData.data()!['cedula'];
          print('Cédula del usuario: $cedula');
          return cedula;
        } else {
          // Si el documento no tiene el campo 'cedula'
          print(
              'Cédula no encontrada en el documento del usuario con correo $email');
          return null;
        }
      } else {
        // Si no se encontró ningún documento para el correo electrónico dado
        print('Documento no encontrado para el usuario con correo $email');
        return null;
      }
    } catch (e) {
      // Manejar excepciones
      print('Error al obtener la cédula del usuario: $e');
      return null; // Otra forma de manejar otros errores
    }
  }

  static Future<Persona?> obtenerDatosUsuario(String email) async {
    try {
      // Realizar una consulta para obtener el documento correspondiente al correo electrónico
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('User_Access')
          .where('email', isEqualTo: email)
          .get();

      // Verificar si se encontró algún documento
      if (querySnapshot.docs.isNotEmpty) {
        // Tomar el primer documento encontrado
        DocumentSnapshot<Map<String, dynamic>> userData =
            querySnapshot.docs.first;

        // Obtener los datos del documento y crear una instancia de Persona
        Map<String, dynamic> userDataMap = userData.data()!;
        Persona usuario = Persona(
          nombre: userDataMap['nombre'],
          apellido: userDataMap['apellido'],
          correo: userDataMap['correo'],
          cedula: userDataMap['cedula'],
          rol: userDataMap['rol'],
          password: userDataMap['password'],
        );
        print('Datos del usuario obtenidos: $usuario');
        return usuario;
      } else {
        // Si no se encontró ningún documento para el correo electrónico dado
        print('Documento no encontrado para el usuario con correo $email');
        return null;
      }
    } catch (e) {
      // Manejar excepciones
      print('Error al obtener los datos del usuario: $e');
      return null; // Otra forma de manejar otros errores
    }
  }
}
