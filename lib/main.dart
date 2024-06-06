import 'package:flutter/material.dart';
import 'package:flutter_application/domain/control/controlAuth.dart';
import 'package:flutter_application/domain/controladores/controlestudiante.dart';
import 'package:flutter_application/ui/app.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application/domain/control/controlDriver.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GetPlatform.isWeb
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
          apiKey: "AIzaSyA6POrIQrp3smQUtdC_01TwXx4kM_OE7UI",
          authDomain: "bikers-logbook.firebaseapp.com",
          projectId: "bikers-logbook",
          storageBucket: "bikers-logbook.appspot.com",
          messagingSenderId: "1086905207797",
          appId: "1:1086905207797:web:65296e3f68d255ace72ebc",
        ))
      : await Firebase.initializeApp();

  runApp(const App());
  Get.put(ControlUserAuth());
  Get.put(EstudianteController());
  Get.put(ControlDriver());
}
