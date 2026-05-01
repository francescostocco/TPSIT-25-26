import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../notifier.dart';
import 'preferito_card.dart';

/// Schermata che mostra l'elenco dei preferiti dell'utente.
class PreferitiScreen extends StatelessWidget {
  const PreferitiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<StruttureNotifier>();
    final preferiti = notifier.preferiti;

    return Scaffold(
      appBar: AppBar(
        title: const Text('I miei preferiti'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          if (notifier.isOffline)
            Container(
              width: double.infinity,
              color: Colors.orange.shade100,
              padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: const Row(
                children: [
                  Icon(Icons.wifi_off, color: Colors.orange, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Modalità offline — modifiche disabilitate',
                      style: TextStyle(color: Colors.orange, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

          Expanded(
            child: preferiti.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        'Nessun preferito.\nTorna alla home e tocca il cuoricino su una struttura per aggiungerla qui!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: preferiti.length,
                    itemBuilder: (_, i) =>
                        PreferitoCard(preferito: preferiti[i]),
                  ),
          ),
        ],
      ),
    );
  }
}