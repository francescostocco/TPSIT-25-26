import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'database_helper.dart';
import 'model.dart';

class StruttureNotifier with ChangeNotifier {
  List<Struttura> _strutture = [];
  List<Preferito> _preferiti = [];
  bool _isLoading = false;
  bool _isOffline = false;

  List<Struttura> get strutture => _strutture;
  List<Preferito> get preferiti => _preferiti;
  bool get isLoading => _isLoading;
  bool get isOffline => _isOffline;

  /// Restituisce il preferito associato alla struttura, o null se non esiste.
  Preferito? preferitoPer(String strutturaId) {
    for (final p in _preferiti) {
      if (p.strutturaId == strutturaId) return p;
    }
    return null;
  }

  /// Restituisce la struttura associata a un preferito.
  Struttura? strutturaPer(String strutturaId) {
    for (final s in _strutture) {
      if (s.id == strutturaId) return s;
    }
    return null;
  }

  Future<void> loadAll() async {
    _isLoading = true;
    notifyListeners();

    final connectivity = await Connectivity().checkConnectivity();
    final online = connectivity != ConnectivityResult.none;

    if (online) {
      try {
        _strutture = await ApiService.getStrutture();
        _preferiti = await ApiService.getPreferiti();
        await DatabaseHelper.saveStrutture(_strutture);
        await DatabaseHelper.savePreferiti(_preferiti);
        _isOffline = false;
      } catch (_) {
        _strutture = await DatabaseHelper.getStrutture();
        _preferiti = await DatabaseHelper.getPreferiti();
        _isOffline = true;
      }
    } else {
      _strutture = await DatabaseHelper.getStrutture();
      _preferiti = await DatabaseHelper.getPreferiti();
      _isOffline = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addPreferito(Preferito p) async {
    final saved = await ApiService.createPreferito(p);
    await DatabaseHelper.upsertPreferito(saved);
    _preferiti.add(saved);
    notifyListeners();
  }

  Future<void> updatePreferito(Preferito p) async {
    final saved = await ApiService.updatePreferito(p);
    await DatabaseHelper.upsertPreferito(saved);
    final idx = _preferiti.indexWhere((x) => x.id == saved.id);
    if (idx != -1) _preferiti[idx] = saved;
    notifyListeners();
  }

  Future<void> patchPriorita(String id, String priorita) async {
    final saved = await ApiService.patchPreferito(id, {'priorita': priorita});
    await DatabaseHelper.upsertPreferito(saved);
    final idx = _preferiti.indexWhere((x) => x.id == id);
    if (idx != -1) _preferiti[idx] = saved;
    notifyListeners();
  }

  Future<void> deletePreferito(String id) async {
    await ApiService.deletePreferito(id);
    await DatabaseHelper.deletePreferito(id);
    _preferiti.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}