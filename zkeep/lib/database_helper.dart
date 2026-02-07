import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'model.dart';

class DatabaseHelper {
  static Future<Database> init() async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  static Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        created_at INTEGER NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE todos (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        note_id INTEGER NOT NULL,
        text TEXT NOT NULL,
        checked INTEGER NOT NULL,
        position INTEGER NOT NULL,
        FOREIGN KEY (note_id) REFERENCES notes (id) ON DELETE CASCADE
      );
    ''');
  }


  static Future<List<Note>> getNotes() async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    Database db = await openDatabase(path, version: 1);

    final List<Map<String, dynamic>> notesResult = await db.query(
      'notes',
      orderBy: 'created_at DESC',
    );

    if (notesResult.isEmpty) {
      return <Note>[];
    }

    List<Note> notes = [];
    for (var noteMap in notesResult) {
      int noteId = noteMap['id'];
      
      final List<Map<String, dynamic>> todosResult = await db.query(
        'todos',
        where: 'note_id = ?',
        whereArgs: [noteId],
        orderBy: 'position ASC',
      );

      List<Todo> todos = todosResult.map((todoMap) {
        return Todo(
          id: todoMap['id'],
          text: todoMap['text'],
          checked: todoMap['checked'] == 1,
        );
      }).toList();

      notes.add(Note(
        id: noteId,
        todos: todos,
      ));
    }

    return notes;
  }

  static Future<int> insertNote(Note note) async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    Database db = await openDatabase(path, version: 1);

    int noteId = await db.insert('notes', {
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });

    for (int i = 0; i < note.todos.length; i++) {
      await db.insert('todos', {
        'note_id': noteId,
        'text': note.todos[i].text,
        'checked': note.todos[i].checked ? 1 : 0,
        'position': i,
      });
    }

    return noteId;
  }

  static Future<void> deleteNote(Note note) async {
    if (note.id == null) return;
    
    String path = join(await getDatabasesPath(), 'zkeep.db');
    Database db = await openDatabase(path, version: 1);

    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  static Future<int> insertTodo(int noteId, Todo todo) async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    Database db = await openDatabase(path, version: 1);

    final result = await db.rawQuery(
      'SELECT MAX(position) as max_pos FROM todos WHERE note_id = ?',
      [noteId],
    );
    
    int nextPosition = 0;
    if (result.isNotEmpty && result.first['max_pos'] != null) {
      nextPosition = (result.first['max_pos'] as int) + 1;
    }

    return await db.insert('todos', {
      'note_id': noteId,
      'text': todo.text,
      'checked': todo.checked ? 1 : 0,
      'position': nextPosition,
    });
  }

  static Future<void> updateTodo(Todo todo) async {
    if (todo.id == null) return;

    String path = join(await getDatabasesPath(), 'zkeep.db');
    Database db = await openDatabase(path, version: 1);

    await db.update(
      'todos',
      {
        'text': todo.text,
        'checked': todo.checked ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  static Future<void> deleteTodo(Todo todo) async {
    if (todo.id == null) return;

    String path = join(await getDatabasesPath(), 'zkeep.db');
    Database db = await openDatabase(path, version: 1);

    await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  static Future<void> deleteAll() async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    Database db = await openDatabase(path, version: 1);

    await db.delete('todos');
    await db.delete('notes');
  }

  static Future<void> seedDatabase() async {
    await deleteAll();

    await insertNote(Note(
      todos: [
        Todo(text: "Comprare il latte"),
        Todo(text: "Pane integrale", checked: true),
        Todo(text: "Frutta fresca"),
      ],
    ));

    await insertNote(Note(
      todos: [
        Todo(text: "Studiare Flutter"),
        Todo(text: "Completare il progetto", checked: true),
      ],
    ));

    await insertNote(Note(
      todos: [
        Todo(text: "Chiamare il dentista"),
      ],
    ));
  }
}
