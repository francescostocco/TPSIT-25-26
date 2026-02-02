import 'package:flutter/material.dart';
import 'model.dart';

class NoteListNotifier with ChangeNotifier {
  final List<Note> _notes = [];

  List<Note> get notes => _notes;

  void addNote() {
    _notes.add(
      Note(
        todos: [Todo(text: "NUOVO PROMEMORIA")],
      ),
    );
    notifyListeners();
  }

  void deleteNote(Note note) {
    _notes.remove(note);
    notifyListeners();
  }

  void addTodo(Note note) {
    note.todos.add(Todo(text: ""));
    notifyListeners();
  }

  void toggleTodo(Todo todo) {
    todo.checked = !todo.checked;
    notifyListeners();
  }

  void updateTodo(Todo todo, String text) {
    todo.text = text;
    notifyListeners();
  }

  void deleteTodo(Note note, Todo todo) {
    note.todos.remove(todo);
    // Se la nota rimane vuota, elimina l'intera card
    if (note.todos.isEmpty) {
      _notes.remove(note);
    }
    notifyListeners();
  }
}