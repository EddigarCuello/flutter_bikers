import 'package:flutter/material.dart';

class PdfViewerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF Viewer"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('/ejemplo.png'), // Asegúrate de que la imagen esté en la carpeta 'assets'
          ),
          SizedBox(height: 20), // Espacio entre la imagen y el botón
        ],
      ),
    );
  }
}
