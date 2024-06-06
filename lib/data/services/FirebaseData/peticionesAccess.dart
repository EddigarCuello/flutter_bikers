import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Peticioneslogin {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<dynamic> crearRegistroEmail(
      dynamic email, dynamic pass, dynamic rol) async {
    Map<String, dynamic> adminRolAccess = {};
    try {
      UserCredential usuario = await auth.createUserWithEmailAndPassword(
          email: email, password: pass);

      print("funcion " + usuario.toString());

      // Obtener el ID único del usuario registrado
      String userId = usuario.user!.uid;

      // Actualizar el campo 'uid' en los datos a guardar
      adminRolAccess['uid'] = userId;
      adminRolAccess['rol'] = rol;
      adminRolAccess['email'] = email;

      // Guardar los datos en Firebase Database
      await _db.collection('Admin_Access').doc(userId).set(adminRolAccess);

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

  /*static Future<dynamic> ingresarEmail(dynamic email, dynamic pass) async {
    try {
      UserCredential usuario =
          await auth.signInWithEmailAndPassword(email: email, password: pass);
      return usuario;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('Correo no encontrado');
        return '1';
      } else if (e.code == 'wrong-password') {
        print('Password incorrecto');
        return '2';
      }
    }
  }*/

  static Future<dynamic> ingresarEmail(dynamic email, dynamic pass) async {
    try {
      // Iniciar sesión con correo electrónico y contraseña
      UserCredential usuario =
          await auth.signInWithEmailAndPassword(email: email, password: pass);

      // Obtener el ID único del usuario autenticado
      /*String userId = usuario.user!.uid;

    // Obtener el rol del usuario
    String? rol = await obtenerRolUsuario(userId);

    if (rol != null) {
      // El rol del usuario se obtuvo correctamente
      print('Rol del usuario: $rol');
    } else {
      // Manejar el caso sin rol
      print('No se pudo obtener el rol del usuario');
    }*/

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

  static Future<String?> obtenerRolUsuario(String email) async {
    try {
      // Realizar una consulta para obtener el documento correspondiente al correo electrónico
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('Admin_Access')
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
}
