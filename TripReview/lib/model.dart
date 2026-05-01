// Helper: converte un valore (String, int, num, null) in String.
// json-server moderno restituisce gli id sempre come String,
// ma manteniamo robustezza accettando anche int.
String _toStr(dynamic v) {
  if (v == null) return '';
  if (v is String) return v;
  return v.toString();
}

String? _toStrOrNull(dynamic v) {
  if (v == null) return null;
  return _toStr(v);
}

int _toInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.parse(v);
  return 0;
}

bool _toBool(dynamic v) {
  if (v is bool) return v;
  if (v is int) return v == 1;
  if (v is String) return v.toLowerCase() == 'true' || v == '1';
  return false;
}

// ─── Modello Struttura (sola lettura dal server) ──────────────────────────────
class Struttura {
  String id;
  String nome;
  String tipo;
  String luogo;
  int stelle;
  int camere;
  bool piscina;
  bool wifi;
  bool colazione;
  bool parcheggio;
  String descrizione;

  Struttura({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.luogo,
    required this.stelle,
    required this.camere,
    required this.piscina,
    required this.wifi,
    required this.colazione,
    required this.parcheggio,
    required this.descrizione,
  });

  factory Struttura.fromJson(Map<String, dynamic> j) => Struttura(
        id: _toStr(j['id']),
        nome: j['nome'] as String,
        tipo: j['tipo'] as String,
        luogo: j['luogo'] as String,
        stelle: _toInt(j['stelle']),
        camere: _toInt(j['camere']),
        piscina: _toBool(j['piscina']),
        wifi: _toBool(j['wifi']),
        colazione: _toBool(j['colazione']),
        parcheggio: _toBool(j['parcheggio']),
        descrizione: j['descrizione'] as String,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'tipo': tipo,
        'luogo': luogo,
        'stelle': stelle,
        'camere': camere,
        'piscina': piscina ? 1 : 0,
        'wifi': wifi ? 1 : 0,
        'colazione': colazione ? 1 : 0,
        'parcheggio': parcheggio ? 1 : 0,
        'descrizione': descrizione,
      };

  factory Struttura.fromMap(Map<String, dynamic> m) => Struttura(
        id: _toStr(m['id']),
        nome: m['nome'] as String,
        tipo: m['tipo'] as String,
        luogo: m['luogo'] as String,
        stelle: _toInt(m['stelle']),
        camere: _toInt(m['camere']),
        piscina: m['piscina'] == 1,
        wifi: m['wifi'] == 1,
        colazione: m['colazione'] == 1,
        parcheggio: m['parcheggio'] == 1,
        descrizione: m['descrizione'] as String,
      );
}

// ─── Modello Preferito ────────────────────────────────────────────────────────
class Preferito {
  String? id;
  String strutturaId;
  String note;
  String priorita;
  String dataAggiunta;

  Preferito({
    this.id,
    required this.strutturaId,
    required this.note,
    required this.priorita,
    required this.dataAggiunta,
  });

  factory Preferito.fromJson(Map<String, dynamic> j) => Preferito(
        id: _toStrOrNull(j['id']),
        strutturaId: _toStr(j['strutturaId']),
        note: j['note'] as String,
        priorita: j['priorita'] as String,
        dataAggiunta: j['dataAggiunta'] as String,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'strutturaId': strutturaId,
        'note': note,
        'priorita': priorita,
        'dataAggiunta': dataAggiunta,
      };

  Map<String, dynamic> toMap() => toJson();

  factory Preferito.fromMap(Map<String, dynamic> m) => Preferito.fromJson(m);
}