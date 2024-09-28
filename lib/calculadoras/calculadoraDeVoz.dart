import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';  // Importa Firebase Firestore

void requestPermissions() async {
  var status = await Permission.microphone.request();
  if (status == PermissionStatus.granted) {
    // Micrófono permitido
  } else {
    // Micrófono denegado
  }
}

class Product {
  String name;
  double price;

  Product(this.name, this.price);

  // Para guardar en Firebase Firestore
  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
      };

  // Para recuperar desde Firebase Firestore
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(json['name'], json['price']);
  }
}

class CalDeVoz extends StatefulWidget {
  const CalDeVoz({super.key});

  @override
  State<CalDeVoz> createState() => _CalDeVozState();
}

class _CalDeVozState extends State<CalDeVoz> {
  SpeechToText speechToText = SpeechToText();

  List<Product> products = []; // Lista de productos

  var text = "Apreta el botón para comenzar a decir los precios!";
  var isListening = false;
  bool isSpeechProcessed = false;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  double getTotal() {
    if (products.isEmpty) {
      return 0; // Si la lista está vacía, devuelve 0
    } else {
      return products.map((product) => product.price).reduce((a, b) => a + b);
    }
  }

  void stopListeningInternally() {
    setState(() {
      isListening = false;
      isSpeechProcessed = false;
    });
    speechToText.stop();
  }

  String processRecognizedWords(String recognizedWords) {
    return recognizedWords.toLowerCase()
        .replaceAll(',', '')
        .replaceAll('por', '*')
        .replaceAll('luca', '1000')
        .replaceAll('lucas', '000')
        .replaceAll('mil', '1000')
        .replaceAll('cero', '0')
        .replaceAll('uno', '1')
        .replaceAll('una', '1')
        .replaceAll('dos', '2')
        .replaceAll('tres', '3')
        .replaceAll('cuatro', '4')
        .replaceAll('cinco', '5')
        .replaceAll('seis', '6')
        .replaceAll('siete', '7')
        .replaceAll('ocho', '8')
        .replaceAll('nueve', '9')
        .replaceAll('diez', '10')
        .replaceAll('once', '11')
        .replaceAll('doce', '12')
        .replaceAll('trece', '13')
        .replaceAll('catorce', '14')
        .replaceAll('quince', '15')
        .replaceAll('coma', '.')
        .replaceAll('punto', '.');
  }

  // Función para guardar productos en Firebase Firestore
  Future<void> saveProductsToFirestore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      CollectionReference productsCollection = firestore.collection('products_history');
      await productsCollection.add({
        'timestamp': FieldValue.serverTimestamp(),
        'total': getTotal(),
        'products': products.map((product) => product.toJson()).toList(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Productos guardados en Firebase')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar productos: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          animate: isListening,
          duration: const Duration(milliseconds: 1000),
          glowColor: Colors.blue,
          child: GestureDetector(
            onTapDown: (details) async {
              if (!isListening && !isSpeechProcessed) {
                var available = await speechToText.initialize();
                if (available) {
                  setState(() {
                    isListening = true;
                    isSpeechProcessed = true;
                    speechToText.listen(
                      onResult: (result) {
                        setState(() {
                          if (result.recognizedWords.isNotEmpty) {
                            String recognizedWords =
                                result.recognizedWords.toLowerCase();

                            // Procesar las palabras y convertirlas a números
                            String processedWords = processRecognizedWords(recognizedWords);

                            double productPrice = 0;
                            try {
                              productPrice = double.parse(processedWords);
                            } catch (e) {
                              text = "Por favor, diga un producto y su precio válido.";
                            }

                            if (productPrice > 0) {
                              products.add(Product("Producto", productPrice));
                            } else {
                              text = "Por favor, diga un producto y su precio válido.";
                            }

                            // Detener la escucha automáticamente después de procesar
                            stopListeningInternally();
                          }
                        });
                      },
                    );
                  });
                }
              }
            },
            onTapUp: (details) {
              stopListeningInternally();
            },
            child: CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 104, 166, 218),
              radius: 35,
              child: Icon(isListening ? Icons.mic : Icons.mic_none,
                  color: Colors.white),
            ),
          ),
        ),
        appBar: AppBar(
          leading: const Icon(Icons.sort_rounded, color: Colors.white),
          centerTitle: true,
          backgroundColor: Colors.blue,
          elevation: 0.0,
          title: const Text(
            "Calculadora Voz",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: saveProductsToFirestore, // Llama a la función para guardar en Firebase
            )
          ],
        ),
        body: SingleChildScrollView(
          reverse: true,
          physics: const BouncingScrollPhysics(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.7,
            alignment: Alignment.center,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            margin: const EdgeInsets.only(bottom: 150),
            child: Column(
              children: [
                Text(
                  text,
                  style: TextStyle(
                      fontSize: 24,
                      color: isListening ? Colors.black54 : Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  'Total: ${getTotal().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 24,
                    color: isListening ? Colors.black54 : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Text(
                  'Productos y Precios:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(products[index].name),
                            Text(products[index].price.toStringAsFixed(2)),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  products.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
