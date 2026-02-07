import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model.dart';
import 'notifier.dart';

/// ======================
/// NOTE CARD
/// ======================
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
          children: [
            Row(
              children: [
                Expanded(
                  child: TitleRow(todo: note.todos.first),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  onPressed: () => notifier.deleteNote(note),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),

            const Divider(height: 16),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: note.todos.skip(1).map((todo) {
                    return TodoRow(note: note, todo: todo);
                  }).toList(),
                ),
              ),
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

/// ======================
/// TITLE ROW 
/// ======================
class TitleRow extends StatefulWidget {
  const TitleRow({super.key, required this.todo});

  final Todo todo;

  @override
  State<TitleRow> createState() => _TitleRowState();
}

class _TitleRowState extends State<TitleRow> {
  bool editing = false;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.todo.text);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<NoteListNotifier>();

    return editing
        ? TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            onSubmitted: (value) {
              notifier.updateTodo(widget.todo, value);
              setState(() => editing = false);
            },
          )
        : GestureDetector(
            onTap: () => setState(() => editing = true),
            child: Text(
              widget.todo.text.isEmpty ? "Titolo..." : widget.todo.text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
  }
}

/// ======================
/// TODO ROW
/// ======================
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
  void dispose() {
    controller.dispose();
    super.dispose();
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
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onSubmitted: (value) {
                    notifier.updateTodo(widget.todo, value);
                    setState(() => editing = false);
                  },
                )
              : GestureDetector(
                  onTap: () => setState(() => editing = true),
                  child: Text(
                    widget.todo.text.isEmpty
                        ? "Nuova nota..."
                        : widget.todo.text,
                    style: TextStyle(
                      decoration: widget.todo.checked
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
        ),

        IconButton(
          icon: const Icon(Icons.close, size: 18),
          onPressed: () => notifier.deleteTodo(widget.note, widget.todo),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}