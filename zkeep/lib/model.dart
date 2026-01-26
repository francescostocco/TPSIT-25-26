class Todo {
  Todo({required this.text, this.checked = false});

  String text;
  bool checked;
}

class Note {
  Note({required this.todos});

  List<Todo> todos;
}
