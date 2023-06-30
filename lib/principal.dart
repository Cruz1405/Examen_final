import 'package:flutter/material.dart';
import 'package:project_final/main.dart';
import 'package:project_final/grupos.dart';

void main() {
  runApp(MyFirst());
}

class MyFirst extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyFristState(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyFristState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla de inicio'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(
                    Size(200, 48)), // Establece un tamaño mínimo personalizado
                padding: MaterialStateProperty.all(
                    EdgeInsets.all(16)), // Ajusta el relleno del botón
                elevation: MaterialStateProperty.all(
                    4), // Ajusta la elevación del botón
              ),
              child: Text('Ir a Personas'),
            ),
            SizedBox(height: 16), // Espacio vertical entre los botones
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyGroup()),
                );
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(
                    Size(200, 48)), // Establece un tamaño mínimo personalizado
                padding: MaterialStateProperty.all(
                    EdgeInsets.all(16)), // Ajusta el relleno del botón
                elevation: MaterialStateProperty.all(
                    4), // Ajusta la elevación del botón
              ),
              child: Text('Ir a Grupos'),
            ),
          ],
        ),
      ),
    );
  }
}
