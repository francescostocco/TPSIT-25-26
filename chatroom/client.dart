import 'dart:io';

late Socket socket;

void main() {
  Socket.connect("localhost", 3000).then((Socket sock) {
    socket = sock;

    socket.listen(gestoreDati,
        onError: gestoreErrore, onDone: gestoreFine, cancelOnError: false);

    stdin.listen(
        (data) => socket.write(String.fromCharCodes(data).trim() + '\n'));
  }, onError: (e) {
    print("Impossibile connettersi: $e");
    exit(1);
  });
}

void gestoreDati(data) {
  stdout.write(String.fromCharCodes(data));
}

void gestoreErrore(error, StackTrace traccia) {
  print("Errore: $error");
}

void gestoreFine() {
  print("Connessione chiusa dal server.");
  socket.destroy();
  exit(0);
}