import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';

/// Servizio HTTP verso json-server.
/// Su emulatore Android usare 10.0.2.2; su dispositivo fisico l'IP locale del PC.
class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000';

  // ── STRUTTURE (sola lettura) ───────────────────────────────────────────────

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

  // ── PREFERITI (CRUD completo) ──────────────────────────────────────────────

  /// GET /preferiti
  static Future<List<Preferito>> getPreferiti() async {
    final res = await http
        .get(Uri.parse('$baseUrl/preferiti'))
        .timeout(const Duration(seconds: 10));

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Preferito.fromJson(e)).toList();
    }
    throw Exception('GET /preferiti fallito: ${res.statusCode}');
  }

  /// POST /preferiti
  static Future<Preferito> createPreferito(Preferito p) async {
    final res = await http
        .post(
          Uri.parse('$baseUrl/preferiti'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(p.toJson()),
        )
        .timeout(const Duration(seconds: 10));

    if (res.statusCode == 201) return Preferito.fromJson(jsonDecode(res.body));
    throw Exception('POST /preferiti fallito: ${res.statusCode}');
  }

  /// PUT /preferiti/{id}
  static Future<Preferito> updatePreferito(Preferito p) async {
    final res = await http
        .put(
          Uri.parse('$baseUrl/preferiti/${p.id}'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(p.toJson()),
        )
        .timeout(const Duration(seconds: 10));

    if (res.statusCode == 200) return Preferito.fromJson(jsonDecode(res.body));
    throw Exception('PUT /preferiti/${p.id} fallito: ${res.statusCode}');
  }

  /// PATCH /preferiti/{id}
  static Future<Preferito> patchPreferito(String id, Map<String, dynamic> fields) async {
    final res = await http
        .patch(
          Uri.parse('$baseUrl/preferiti/$id'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(fields),
        )
        .timeout(const Duration(seconds: 10));

    if (res.statusCode == 200) return Preferito.fromJson(jsonDecode(res.body));
    throw Exception('PATCH /preferiti/$id fallito: ${res.statusCode}');
  }

  /// DELETE /preferiti/{id}
  static Future<void> deletePreferito(String id) async {
    final res = await http
        .delete(Uri.parse('$baseUrl/preferiti/$id'))
        .timeout(const Duration(seconds: 10));

    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('DELETE /preferiti/$id fallito: ${res.statusCode}');
    }
  }
}