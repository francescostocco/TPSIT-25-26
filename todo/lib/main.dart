import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model.dart';
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
      title: 'todo_app',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.red)),
      home: ChangeNotifierProvider<TodoListNotifier>(
        create: (notifier) => TodoListNotifier(),
        child: const MyHomePage(title: 'Todo App'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<TodoListNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 8),
        itemCount: notifier.length,
        itemBuilder: (context, index) {
          Todo todo = notifier.getTodo(index);
          return TodoItem(todo: todo);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          notifier.addTodo("");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
