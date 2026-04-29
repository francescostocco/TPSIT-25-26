import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'model.dart';

/// Helper per il database SQLite locale.
/// Stessa struttura di zkeep: metodi statici, apertura db a ogni chiamata.
/// Usato come cache: i dati freschi dal server vengono scritti qui,
/// e vengono letti quando il server non è raggiungibile.
class DatabaseHelper {
  static Future<Database> _open() async {
    final path = join(await getDatabasesPath(), 'tripreview.db');
    return openDatabase(path, version: 1, onCreate: _createTables);
  }

  static Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE strutture (
        id          INTEGER PRIMARY KEY,
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
      CREATE TABLE recensioni (
        id          INTEGER PRIMARY KEY,
        strutturaId INTEGER NOT NULL,
        titolo      TEXT    NOT NULL,
        descrizione TEXT    NOT NULL,
        voto        INTEGER NOT NULL
      )
    ''');
  }

  // ── STRUTTURE ──────────────────────────────────────────────────────────────

  static Future<List<Struttura>> getStrutture() async {
    final db = await _open();
    final rows = await db.query('strutture');
    return rows.map(Struttura.fromMap).toList();
  }

  /// Sovrascrive tutta la cache delle strutture con i dati freschi dal server.
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

  static Future<void> upsertStruttura(Struttura s) async {
    final db = await _open();
    await db.insert('strutture', s.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> deleteStruttura(int id) async {
    final db = await _open();
    await db.delete('strutture', where: 'id = ?', whereArgs: [id]);
    // Rimuove anche le recensioni associate
    await db.delete('recensioni', where: 'strutturaId = ?', whereArgs: [id]);
  }

  // ── RECENSIONI ─────────────────────────────────────────────────────────────

  static Future<List<Recensione>> getRecensioni(int strutturaId) async {
    final db = await _open();
    final rows = await db.query('recensioni',
        where: 'strutturaId = ?', whereArgs: [strutturaId]);
    return rows.map(Recensione.fromMap).toList();
  }

  static Future<void> saveRecensioni(
      List<Recensione> recensioni, int strutturaId) async {
    final db = await _open();
    final batch = db.batch();
    batch.delete('recensioni',
        where: 'strutturaId = ?', whereArgs: [strutturaId]);
    for (final r in recensioni) {
      batch.insert('recensioni', r.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  static Future<void> upsertRecensione(Recensione r) async {
    final db = await _open();
    await db.insert('recensioni', r.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> deleteRecensione(int id) async {
    final db = await _open();
    await db.delete('recensioni', where: 'id = ?', whereArgs: [id]);
  }
}