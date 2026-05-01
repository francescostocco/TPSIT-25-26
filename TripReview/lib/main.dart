import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'notifier.dart';
import 'widgets/struttura_card.dart';
import 'widgets/preferiti_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Il provider sta SOPRA il MaterialApp così tutte le route
    // (HomePage, PreferitiScreen, FormPreferitoScreen) condividono
    // la stessa istanza di StruttureNotifier.
    return ChangeNotifierProvider(
      create: (_) => StruttureNotifier(),
      child: MaterialApp(
        title: 'TripReview',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<StruttureNotifier>().loadAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<StruttureNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('TripReview'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          // Badge con contatore preferiti
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.favorite),
                tooltip: 'I miei preferiti',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PreferitiScreen(),
                  ),
                ),
              ),
              if (notifier.preferiti.isNotEmpty)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                        minWidth: 16, minHeight: 16),
                    child: Text(
                      '${notifier.preferiti.length}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Aggiorna',
            onPressed: () => notifier.loadAll(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner offline
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
                      'Modalità offline — visualizzazione dati in cache',
                      style: TextStyle(color: Colors.orange, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

          Expanded(
            child: notifier.isLoading
                ? const Center(child: CircularProgressIndicator())
                : notifier.strutture.isEmpty
                    ? const Center(
                        child: Text(
                          'Nessuna struttura.\nAvvia json-server per caricare i dati!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: notifier.strutture.length,
                        itemBuilder: (_, i) =>
                            StrutturaCard(struttura: notifier.strutture[i]),
                      ),
          ),
        ],
      ),
    );
  }
}