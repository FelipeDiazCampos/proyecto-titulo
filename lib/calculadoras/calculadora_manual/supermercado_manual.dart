import 'package:flutter/material.dart';
import 'package:supcalculadora/calculadoras/calculadora_manual/calculadora_manual.dart';// Asegúrate de tener esta pantalla

class SupermarketSelection_manual extends StatefulWidget {
  const SupermarketSelection_manual({super.key});

  @override
  _SupermarketSelection_manualState createState() => _SupermarketSelection_manualState();
}

class _SupermarketSelection_manualState extends State<SupermarketSelection_manual> {
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
        title: const Text('Seleccionar Supermercado',
        style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white)),
        backgroundColor: const Color(0xFF36bfed),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF36bfed),
              Color.fromARGB(255, 197, 235, 248),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '¿A qué supermercado vas a ir?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 20,
                children: [
                  buildSupermarketOption('Jumbo', 'assets/jumbo.png'),
                  buildSupermarketOption('Lider', 'assets/lider.png'),
                  buildSupermarketOption('Santa Isabel', 'assets/santa_isabel.png'),
                  buildSupermarketOption('Unimarc', 'assets/unimarc.png'),
                  buildSupermarketOption('Tottus', 'assets/tottus.png'),
                  buildSupermarketOption('Acuenta', 'assets/acuenta.png'),
                  buildSupermarketOption('otros', 'assets/designer.png'),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: selectedSupermarket != null
                    ? () {
                        // Redirigir a la calculadora de voz pasando el supermercado seleccionado
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CalculadoraM(supermarket: selectedSupermarket!),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Color del botón OK
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                ), // Deshabilitar si no se ha seleccionado un supermercado
                child: const Icon(Icons.check, size: 30, color: Color.fromARGB(255, 255, 255, 255),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para mostrar cada supermercado con una imagen
  Widget buildSupermarketOption(String name, String assetPath) {
    return GestureDetector(
      onTap: () => selectSupermarket(name),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Set background color to white
          border: Border.all(
            color: selectedSupermarket == name ? Colors.green : const Color.fromARGB(255, 105, 105, 105),
            width: 2,
          ),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Image.asset(assetPath, width: 100, height: 100), // Imagen del supermercado
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}