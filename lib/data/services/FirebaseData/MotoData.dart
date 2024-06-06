import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application/domain/modelos/moto.dart';

class MotoData {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<dynamic> GuardarMoto(Moto moto) async {
    Map<String, dynamic> motoDatas = {};
    try {
      // Actualizar el campo 'uid' en los datos a guardar
      motoDatas['cedula_admin'] = moto.ccAdmin;
      motoDatas['cedula_conductor'] = moto.ccConductor;
      motoDatas['kilometraje'] = moto.kilometraje;
      motoDatas['placa'] = moto.placa;
      motoDatas['estado'] = moto.estado;
      // Actualizar el documento en Firebase Database
      await _db.collection('Bikes').doc(moto.placa).set(motoDatas);

      // Puedes devolver algún tipo de confirmación si lo necesitas
      return 'Moto Agregada exitosamente';
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> CambiarEstado(String placa, String estado) async {
    Map<String, dynamic> motoEstado = {};
    try {
      // Actualizar los campos en un documento existente en lugar de crear uno nuevo
      motoEstado['estado'] = estado;
      // Actualizar el documento en Firebase Database
      await _db.collection('Bikes').doc(placa).update(motoEstado);

      // Puedes devolver algún tipo de confirmación si lo necesitas
      return 'Documento actualizado exitosamente';
    } catch (e) {
      print(e);
      // Manejo de errores si es necesario
      return null;
    }
  }

  static Future<dynamic> CambiarKilometraje(
      String placa, String kilometraje) async {
    Map<String, dynamic> motoEstado = {};
    try {
      // Actualizar los campos en un documento existente en lugar de crear uno nuevo
      motoEstado['kilometraje'] = kilometraje;
      // Actualizar el documento en Firebase Database
      await _db.collection('Bikes').doc(placa).update(motoEstado);

      // Puedes devolver algún tipo de confirmación si lo necesitas
      return 'Documento actualizado exitosamente';
    } catch (e) {
      print(e);
      // Manejo de errores si es necesario
      return null;
    }
  }

  static Future<Map<String, dynamic>?> findBikeBy(
      String campo, String valor) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _db.collection('Bikes').where(campo, isEqualTo: valor).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> userData =
            querySnapshot.docs.first;
        Map<String, dynamic> motoData = userData.data()!;
        print('Datos del conductor: $motoData');
        return motoData;
      } else {
        print('Documento no encontrado para el campo $campo con valor $valor');
        return null;
      }
    } catch (e) {
      print('Error al obtener el conductor por $campo: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> findBikesBy(
      String campo, String valor) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _db.collection('Bikes').where(campo, isEqualTo: valor).get();

      if (querySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> motosData =
            querySnapshot.docs.map((doc) => doc.data()).toList();
        print('Datos de las motos: $motosData');
        return motosData;
      } else {
        print('Documento no encontrado para el campo $campo con valor $valor');
        return null;
      }
    } catch (e) {
      print('Error al obtener las motos por $campo: $e');
      return null;
    }
  }
}
