// ─── Modello Struttura ────────────────────────────────────────────────────────
class Struttura {
  int? id;
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
    this.id,
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
        id: j['id'] as int?,
        nome: j['nome'] as String,
        tipo: j['tipo'] as String,
        luogo: j['luogo'] as String,
        stelle: j['stelle'] as int,
        camere: j['camere'] as int,
        piscina: j['piscina'] as bool,
        wifi: j['wifi'] as bool,
        colazione: j['colazione'] as bool,
        parcheggio: j['parcheggio'] as bool,
        descrizione: j['descrizione'] as String,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'nome': nome,
        'tipo': tipo,
        'luogo': luogo,
        'stelle': stelle,
        'camere': camere,
        'piscina': piscina,
        'wifi': wifi,
        'colazione': colazione,
        'parcheggio': parcheggio,
        'descrizione': descrizione,
      };

  // Per SQLite i bool vengono salvati come 0/1
  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
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
        id: m['id'] as int?,
        nome: m['nome'] as String,
        tipo: m['tipo'] as String,
        luogo: m['luogo'] as String,
        stelle: m['stelle'] as int,
        camere: m['camere'] as int,
        piscina: m['piscina'] == 1,
        wifi: m['wifi'] == 1,
        colazione: m['colazione'] == 1,
        parcheggio: m['parcheggio'] == 1,
        descrizione: m['descrizione'] as String,
      );
}

// ─── Modello Recensione ───────────────────────────────────────────────────────
class Recensione {
  int? id;
  int strutturaId;
  String titolo;
  String descrizione;
  int voto; // 1–5

  Recensione({
    this.id,
    required this.strutturaId,
    required this.titolo,
    required this.descrizione,
    required this.voto,
  });

  factory Recensione.fromJson(Map<String, dynamic> j) => Recensione(
        id: j['id'] as int?,
        strutturaId: j['strutturaId'] as int,
        titolo: j['titolo'] as String,
        descrizione: j['descrizione'] as String,
        voto: j['voto'] as int,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'strutturaId': strutturaId,
        'titolo': titolo,
        'descrizione': descrizione,
        'voto': voto,
      };

  Map<String, dynamic> toMap() => toJson();

  factory Recensione.fromMap(Map<String, dynamic> m) => Recensione.fromJson(m);
}