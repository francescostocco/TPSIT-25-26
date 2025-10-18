import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: InferiorMind(),
    debugShowCheckedModeBanner: false,
  ));
}

class InferiorMind extends StatefulWidget {
  const InferiorMind({super.key});

  @override
  State<InferiorMind> createState() => _InferiorMindState();
}

class _InferiorMindState extends State<InferiorMind> {

  final List<Color> colori = [Colors.red, Colors.green, Colors.blue, Colors.yellow];
  List<int> segreto = [];
  List<int> scelta = [-1, -1, -1, -1]; 

  @override
  void initState() {
    super.initState();
    _generaSegreto();
  }

  void _generaSegreto() {
    final r = Random();
    segreto = List.generate(4, (_) => r.nextInt(colori.length));
  }

  void _cambiaColore(int i) {
    setState(() {
      if (scelta[i] == -1) {
        scelta[i] = 0;
      } else {
        scelta[i] = (scelta[i] + 1) % colori.length;
      }
    });
  }

  void _verifica() {
    bool giusto = true;
    for (int i = 0; i < 4; i++) {
      if (scelta[i] != segreto[i]) giusto = false;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(giusto ? 'Hai indovinato!' : 'Riprova!'),
        content: const Text('Premi OK per continuare'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                scelta = [-1, -1, -1, -1];
                _generaSegreto();
              });
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inferior Mind')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Tocca i cerchi per cambiare colore',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) {
              Color colore = scelta[i] == -1 ? Colors.grey : colori[scelta[i]];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => _cambiaColore(i),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colore,
                    shape: const CircleBorder(),
                    minimumSize: const Size(60, 60),
                  ),
                  child: const SizedBox.shrink(),
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _verifica,
        label: const Text('Verifica'),
        icon: const Icon(Icons.check),
        backgroundColor: Colors.red,
      ),
    );
  }
}
