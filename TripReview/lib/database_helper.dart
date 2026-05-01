import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'model.dart';

/// Helper per il database SQLite locale, usato come cache.
class DatabaseHelper {
  static Future<Database> _open() async {
    final path = join(await getDatabasesPath(), 'tripreview.db');
    // Versione 4: schema con id TEXT (json-server v1 usa id stringa).
    return openDatabase(
      path,
      version: 4,
      onCreate: _createTables,
      onUpgrade: (db, oldV, newV) async {
        await db.execute('DROP TABLE IF EXISTS strutture');
        await db.execute('DROP TABLE IF EXISTS preferiti');
        await _createTables(db, newV);
      },
    );
  }

  static Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE strutture (
        id          TEXT    PRIMARY KEY,
        nome        TEXT    NOT NULL,
        tipo        TEXT    NOT NULL,
        luogo       TEXT    NOT NULL,
        stelle      INTEGER NOT NULL,
        camere      INTEGER NOT NULL,
        piscina     INTEGER NOT NULL,
        wifi        INTEGER NOT NULL,
        colazione   INTEGER NOT NULL,
        parcheggio  INTEGER NOT NULL,
        descrizione TEXT    NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE preferiti (
        id           TEXT    PRIMARY KEY,
        strutturaId  TEXT    NOT NULL,
        note         TEXT    NOT NULL,
        priorita     TEXT    NOT NULL,
        dataAggiunta TEXT    NOT NULL
      )
    ''');
  }

  // ── STRUTTURE ──────────────────────────────────────────────────────────────

  static Future<List<Struttura>> getStrutture() async {
    final db = await _open();
    final rows = await db.query('strutture');
    return rows.map(Struttura.fromMap).toList();
  }

  static Future<void> saveStrutture(List<Struttura> strutture) async {
    final db = await _open();
    final batch = db.batch();
    batch.delete('strutture');
    for (final s in strutture) {
      batch.insert('strutture', s.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  // ── PREFERITI ──────────────────────────────────────────────────────────────

  static Future<List<Preferito>> getPreferiti() async {
    final db = await _open();
    final rows = await db.query('preferiti');
    return rows.map(Preferito.fromMap).toList();
  }

  static Future<void> savePreferiti(List<Preferito> preferiti) async {
    final db = await _open();
    final batch = db.batch();
    batch.delete('preferiti');
    for (final p in preferiti) {
      batch.insert('preferiti', p.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  static Future<void> upsertPreferito(Preferito p) async {
    final db = await _open();
    await db.insert('preferiti', p.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> deletePreferito(String id) async {
    final db = await _open();
    await db.delete('preferiti', where: 'id = ?', whereArgs: [id]);
  }
}