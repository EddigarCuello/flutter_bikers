import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application/domain/modelos/horario.dart';

class TimeData {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<dynamic> GuardarHorario(Horario dtime) async {
    try {
      // Crear el mapa de datos sin verificar si están vacíos
      Map<String, dynamic> timeData = {
        'placa': dtime.placa,
        'fecha_inicio': dtime.fechaInicio,
        'fecha_cierre': dtime.fechaCierre,
        'hora_inicio': dtime.horaInicio,
        'hora_cierre': dtime.horaCierre,
        'kilometros': dtime.kilometros,
        'valor':dtime.valor,
      };

      // Comprobar si el documento existe
      var docRef = _db.collection('Timetable').doc(dtime.fechaInicio);
      var docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Editar el documento existente
        await docRef.set(timeData, SetOptions(merge: true));
        return 'Horario actualizado exitosamente';
      } else {
        // Crear un nuevo documento
        await docRef.set(timeData);
        return 'Horario agregado exitosamente';
      }
    } catch (e) {
      print(e);
      return 'Error al guardar el horario';
    }
  }

  static Future<Map<String, dynamic>?> findTimeBy(
      String campo, String valor) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('Timetable')
          .where(campo, isEqualTo: valor)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> userData =
            querySnapshot.docs.first;
        Map<String, dynamic> timeData = userData.data()!;
        print('horario: $timeData');
        return timeData;
      } else {
        print('Documento no encontrado para el campo $campo con valor $valor');
        return null;
      }
    } catch (e) {
      print('Error al obtener el conductor por $campo: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> findTimesBy(
      String campo, String valor) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('Timetable')
          .where(campo, isEqualTo: valor)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> timesData =
            querySnapshot.docs.map((doc) => doc.data()).toList();
        print('Horarios: $timesData');
        return timesData;
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
