import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'notifier.dart';
import 'widgets.dart';
import 'database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await DatabaseHelper.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZKeep',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: ChangeNotifierProvider(
        create: (_) => NoteListNotifier(),
        child: const HomePage(),
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
      context.read<NoteListNotifier>().loadNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<NoteListNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("ZKeep"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Carica dati di esempio',
            onPressed: () async {
              await notifier.seedDatabase();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Database popolato con dati di esempio')),
                );
              }
            },
          ),
        ],
      ),
      body: notifier.isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifier.notes.isEmpty
              ? const Center(
                  child: Text(
                    'Nessuna nota.\nPremi + per aggiungerne una!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.7, // Card più alte
                  ),
                  itemCount: notifier.notes.length,
                  itemBuilder: (context, index) {
                    return NoteCard(note: notifier.notes[index]);
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => notifier.addNote(),
        child: const Icon(Icons.note_add),
      ),
    );
  }
}
