class Todo {
  Todo({this.id, required this.text, this.checked = false});

  int? id;
  String text;
  bool checked;
}

class Note {
  Note({this.id, required this.todos});

  int? id;
  List<Todo> todos;
}
