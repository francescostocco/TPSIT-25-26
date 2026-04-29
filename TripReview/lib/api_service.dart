import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';

/// Servizio HTTP verso json-server.
/// Cambia [baseUrl] con l'IP della macchina host se usi un dispositivo fisico.
/// Esempio: 'http://192.168.1.100:3000'
class ApiService {
  static const String baseUrl = 'http://localhost:3000';

  // ── STRUTTURE ──────────────────────────────────────────────────────────────

  /// GET /strutture
  static Future<List<Struttura>> getStrutture() async {
    final res = await http
        .get(Uri.parse('$baseUrl/strutture'))
        .timeout(const Duration(seconds: 10));

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Struttura.fromJson(e)).toList();
    }
    throw Exception('GET /strutture fallito: ${res.statusCode}');
  }

  /// POST /strutture
  static Future<Struttura> createStruttura(Struttura s) async {
    final res = await http
        .post(
          Uri.parse('$baseUrl/strutture'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(s.toJson()),
        )
        .timeout(const Duration(seconds: 10));

    if (res.statusCode == 201) return Struttura.fromJson(jsonDecode(res.body));
    throw Exception('POST /strutture fallito: ${res.statusCode}');
  }

  /// PUT /strutture/{id} — sostituzione completa
  static Future<Struttura> updateStruttura(Struttura s) async {
    final res = await http
        .put(
          Uri.parse('$baseUrl/strutture/${s.id}'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(s.toJson()),
        )
        .timeout(const Duration(seconds: 10));

    if (res.statusCode == 200) return Struttura.fromJson(jsonDecode(res.body));
    throw Exception('PUT /strutture/${s.id} fallito: ${res.statusCode}');
  }

  /// PATCH /strutture/{id} — aggiornamento parziale (es. solo stelle)
  static Future<Struttura> patchStruttura(int id, Map<String, dynamic> fields) async {
    final res = await http
        .patch(
          Uri.parse('$baseUrl/strutture/$id'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(fields),
        )
        .timeout(const Duration(seconds: 10));

    if (res.statusCode == 200) return Struttura.fromJson(jsonDecode(res.body));
    throw Exception('PATCH /strutture/$id fallito: ${res.statusCode}');
  }

  /// DELETE /strutture/{id}
  static Future<void> deleteStruttura(int id) async {
    final res = await http
        .delete(Uri.parse('$baseUrl/strutture/$id'))
        .timeout(const Duration(seconds: 10));

    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('DELETE /strutture/$id fallito: ${res.statusCode}');
    }
  }

  // ── RECENSIONI ─────────────────────────────────────────────────────────────

  /// GET /recensioni?strutturaId=X
  static Future<List<Recensione>> getRecensioni(int strutturaId) async {
    final uri = Uri.parse('$baseUrl/recensioni')
        .replace(queryParameters: {'strutturaId': '$strutturaId'});
    final res = await http.get(uri).timeout(const Duration(seconds: 10));

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Recensione.fromJson(e)).toList();
    }
    throw Exception('GET /recensioni fallito: ${res.statusCode}');
  }

  /// POST /recensioni
  static Future<Recensione> createRecensione(Recensione r) async {
    final res = await http
        .post(
          Uri.parse('$baseUrl/recensioni'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(r.toJson()),
        )
        .timeout(const Duration(seconds: 10));

    if (res.statusCode == 201) return Recensione.fromJson(jsonDecode(res.body));
    throw Exception('POST /recensioni fallito: ${res.statusCode}');
  }

  /// PUT /recensioni/{id}
  static Future<Recensione> updateRecensione(Recensione r) async {
    final res = await http
        .put(
          Uri.parse('$baseUrl/recensioni/${r.id}'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(r.toJson()),
        )
        .timeout(const Duration(seconds: 10));

    if (res.statusCode == 200) return Recensione.fromJson(jsonDecode(res.body));
    throw Exception('PUT /recensioni/${r.id} fallito: ${res.statusCode}');
  }

  /// PATCH /recensioni/{id} — es. aggiorna solo il voto
  static Future<Recensione> patchRecensione(int id, Map<String, dynamic> fields) async {
    final res = await http
        .patch(
          Uri.parse('$baseUrl/recensioni/$id'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(fields),
        )
        .timeout(const Duration(seconds: 10));

    if (res.statusCode == 200) return Recensione.fromJson(jsonDecode(res.body));
    throw Exception('PATCH /recensioni/$id fallito: ${res.statusCode}');
  }

  /// DELETE /recensioni/{id}
  static Future<void> deleteRecensione(int id) async {
    final res = await http
        .delete(Uri.parse('$baseUrl/recensioni/$id'))
        .timeout(const Duration(seconds: 10));

    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('DELETE /recensioni/$id fallito: ${res.statusCode}');
    }
  }
}