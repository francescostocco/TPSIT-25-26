import 'package:flutter/material.dart';
import 'model.dart';
import 'database_helper.dart';

class NoteListNotifier with ChangeNotifier {
  List<Note> _notes = [];
  bool _isLoading = false;

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;

  Future<void> loadNotes() async {
    _isLoading = true;
    notifyListeners();

    _notes = await DatabaseHelper.getNotes();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addNote() async {
    Note newNote = Note(
      todos: [Todo(text: "NUOVO PROMEMORIA")],
    );
    
    int noteId = await DatabaseHelper.insertNote(newNote);
    newNote.id = noteId;
    
    await loadNotes();
  }

  Future<void> deleteNote(Note note) async {
    await DatabaseHelper.deleteNote(note);
    await loadNotes();
  }

  Future<void> addTodo(Note note) async {
    if (note.id == null) return;

    Todo newTodo = Todo(text: "");
    await DatabaseHelper.insertTodo(note.id!, newTodo);
    await loadNotes();
  }

  Future<void> toggleTodo(Todo todo) async {
    todo.checked = !todo.checked;
    await DatabaseHelper.updateTodo(todo);
    notifyListeners(); 
  }

  Future<void> updateTodo(Todo todo, String text) async {
    todo.text = text;
    await DatabaseHelper.updateTodo(todo);
    notifyListeners(); 
  }

  Future<void> deleteTodo(Note note, Todo todo) async {
    await DatabaseHelper.deleteTodo(todo);
    
    note.todos.remove(todo);
    
    if (note.todos.isEmpty) {
      await DatabaseHelper.deleteNote(note);
    }
    
    await loadNotes();
  }

  Future<void> seedDatabase() async {
    await DatabaseHelper.seedDatabase();
    await loadNotes();
  }
}
