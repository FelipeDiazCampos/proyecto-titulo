import 'package:flutter/material.dart';
import 'package:supcalculadora/calculadoras/calculadora_manual/calculadora_manual.dart'; // Asegúrate de tener esta pantalla

class SupermarketSelectionManual extends StatefulWidget {
  const SupermarketSelectionManual({super.key});

  @override
  _SupermarketSelectionManualState createState() =>
      _SupermarketSelectionManualState();
}

class _SupermarketSelectionManualState
    extends State<SupermarketSelectionManual> {
  String? selectedSupermarket; // Almacena el supermercado seleccionado

  // Función para seleccionar un supermercado
  void selectSupermarket(String supermarket) {
    setState(() {
      selectedSupermarket = supermarket;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF36bfed),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF36bfed),
              Color.fromARGB(255, 197, 235, 248),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Espaciado para evitar recortes
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '¿A qué supermercado vas a ir?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      buildSupermarketOption('Jumbo', 'assets/jumbo.png'),
                      buildSupermarketOption('Lider', 'assets/lider.png'),
                      buildSupermarketOption(
                          'Santa Isabel', 'assets/santa_isabel.png'),
                      buildSupermarketOption('Unimarc', 'assets/unimarc.png'),
                      buildSupermarketOption('Tottus', 'assets/tottus.png'),
                      buildSupermarketOption('Acuenta', 'assets/acuenta.png'),
                      buildSupermarketOption('Otros', 'assets/designer.png'),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: selectedSupermarket != null
                          ? () {
                              // Redirigir a la calculadora manual pasando el supermercado seleccionado
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CalculadoraM(
                                      supermarket: selectedSupermarket!),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Color del botón OK
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                      ), // Deshabilitar si no se ha seleccionado un supermercado
                      child: const Icon(
                        Icons.check,
                        size: 30,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget para mostrar cada supermercado con una imagen
  Widget buildSupermarketOption(String name, String assetPath) {
    double width = MediaQuery.of(context).size.width * 0.4; // Responsivo al ancho

    return GestureDetector(
      onTap: () => selectSupermarket(name),
      child: Container(
        width: width, // Ajusta el ancho basado en el tamaño de la pantalla
        decoration: BoxDecoration(
          color: Colors.white, // Fondo blanco para los contenedores
          border: Border.all(
            color: selectedSupermarket == name
                ? Colors.green
                : const Color.fromARGB(255, 105, 105, 105),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10), // Bordes redondeados
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Image.asset(
              assetPath,
              width: 80, // Tamaño responsivo para imágenes
              height: 80,
              fit: BoxFit.contain,
            ), // Imagen del supermercado
            const SizedBox(height: 8),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
