import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:flutter_application/domain/control/controlAuth.dart';
import 'package:get/get.dart';

class Peticiones {
  static final ControlUserAuth controlua = Get.find();
  static final fs.FirebaseStorage storage = fs.FirebaseStorage.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> crearRolAccess(Map<String, dynamic> datosAcceso) async {
    datosAcceso['uid'] = controlua.userValido!.user!.uid;
    await _db
        .collection('Admin_Access')
        .doc(controlua.userValido!.user!.uid)
        .set(datosAcceso)
        .catchError((e) {
      print(e);
    });
    //return true;
  }

  static Future<void> actualizarcatalogo(
      String id, Map<String, dynamic> catalogo) async {
    await _db
        .collection('Admin_Access')
        .doc(id)
        .update(catalogo)
        .catchError((e) {
      print(e);
    });
    //return true;
  }

  static Future<void> eliminarcatalogo(String id) async {
    await _db.collection('Admin_Access').doc(id).delete().catchError((e) {
      print(e);
    });
    //return true;
  }
}
