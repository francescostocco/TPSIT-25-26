import 'dart:io';

late ServerSocket serverSocket;
List<ChatClient> clienti = [];

void main() {
  ServerSocket.bind(InternetAddress.anyIPv4, 3000).then((ServerSocket socket) {
    serverSocket = socket;
    print('Server in ascolto sulla porta ${3000}...');
    serverSocket.listen((client) {
      handleConnection(client);
    });
  });
}

void handleConnection(Socket client) {
  print('Connessione da '
      '${client.remoteAddress.address}:${client.remotePort}');

  ChatClient nuovoClient = ChatClient(client);
  clienti.add(nuovoClient);

  client.write("Benvenuto nella Chat Dart! Inserisci il tuo username: \n");
}

void rimuoviClient(ChatClient client) {
  distribuisciMessaggio(client, '${client.nomeUtente} ha lasciato la chat.');
  clienti.remove(client);

  print('${client._indirizzo}:${client._porta} disconnesso.');
}

void distribuisciMessaggio(ChatClient clientMittente, String messaggio) {
  for (ChatClient c in clienti) {
    if (c != clientMittente) {
      c.write(messaggio + "\n");
    }
  }
}

class ChatClient {
  late Socket _socket;
  String nomeUtente = "Anonimo";
  bool _nomeImpostato = false;

  String get _indirizzo => _socket.remoteAddress.address;
  int get _porta => _socket.remotePort;

  ChatClient(Socket s) {
    _socket = s;
    _socket.listen(gestoreMessaggio,
        onError: gestoreErrore, onDone: gestoreFine);
  }

  void gestoreMessaggio(data) {
    String messaggio = String.fromCharCodes(data).trim();

    if (!_nomeImpostato) {
      nomeUtente = messaggio.isNotEmpty ? messaggio : "Anonimo-${_porta}";
      _nomeImpostato = true;

      _socket.write(
          "Ciao, $nomeUtente! Ci sono ${clienti.length - 1} altri utenti online.\n");

      distribuisciMessaggio(this, '$nomeUtente si è unito alla chat.');
    } else {
      String messaggioFormattato = '$nomeUtente: $messaggio';
      distribuisciMessaggio(this, messaggioFormattato);
    }
  }

  void gestoreErrore(error) {
    print('${_indirizzo}:${_porta} Errore: $error');
    rimuoviClient(this);
    _socket.close();
  }

  void gestoreFine() {
    rimuoviClient(this);
    _socket.close();
  }

  void write(String messaggio) {
    _socket.write(messaggio);
  }
}
