import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model.dart';
import 'notifier.dart';

class TodoItem extends StatefulWidget {
  const TodoItem({super.key, required this.todo});

  final Todo todo;

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  bool editing = false;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.todo.name);
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<TodoListNotifier>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Checkbox(
              value: widget.todo.checked,
              onChanged: (_) => notifier.toggleTodo(widget.todo),
            ),
            const SizedBox(width: 8),

            Expanded(
              child: editing
                  ? TextField(
                      controller: controller,
                      autofocus: true,
                      onSubmitted: (value) {
                        notifier.updateTodoText(widget.todo, value);
                        setState(() => editing = false);
                      },
                      onEditingComplete: () {
                        notifier.updateTodoText(widget.todo, controller.text);
                        setState(() => editing = false);
                      },
                    )
                  : GestureDetector(
                      onTap: () {
                        setState(() => editing = true);
                      },
                      onLongPress: () {
                        notifier.deleteTodo(widget.todo);
                      },
                      child: Text(
                        widget.todo.name.isEmpty
                            ? "Nuova nota"
                            : widget.todo.name,
                        style: TextStyle(
                          fontSize: 16,
                          color: widget.todo.checked
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
