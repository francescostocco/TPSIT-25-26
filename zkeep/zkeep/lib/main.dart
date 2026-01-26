import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'notifier.dart';
import 'widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Keep',
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<NoteListNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo Keep"),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
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
