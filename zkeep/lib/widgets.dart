import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model.dart';
import 'notifier.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({super.key, required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<NoteListNotifier>();

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...note.todos.map(
              (todo) => TodoRow(note: note, todo: todo),
            ),
            TextButton.icon(
              onPressed: () => notifier.addTodo(note),
              icon: const Icon(Icons.add),
              label: const Text("Aggiungi"),
            ),
          ],
        ),
      ),
    );
  }
}

class TodoRow extends StatefulWidget {
  const TodoRow({super.key, required this.note, required this.todo});

  final Note note;
  final Todo todo;

  @override
  State<TodoRow> createState() => _TodoRowState();
}

class _TodoRowState extends State<TodoRow> {
  bool editing = false;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.todo.text);
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<NoteListNotifier>();

    return Row(
      children: [
        Checkbox(
          value: widget.todo.checked,
          onChanged: (_) => notifier.toggleTodo(widget.todo),
        ),
        Expanded(
          child: editing
              ? TextField(
                  controller: controller,
                  autofocus: true,
                  onSubmitted: (value) {
                    notifier.updateTodo(widget.todo, value);
                    setState(() => editing = false);
                  },
                )
              : GestureDetector(
                  onTap: () => setState(() => editing = true),
                  onLongPress: () =>
                      notifier.deleteTodo(widget.note, widget.todo),
                  child: Text(
                    widget.todo.text.isEmpty
                        ? "Nuova nota..."
                        : widget.todo.text,
                  ),
                ),
        ),
      ],
    );
  }
}
