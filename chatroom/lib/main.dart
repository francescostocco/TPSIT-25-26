import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Socket? socket;
  List<String> messages = [];
  TextEditingController inputController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  bool connected = false;
  bool usernameSent = false;

  // Connessione al server
  Future<void> connect() async {
    socket =
        await Socket.connect("10.0.2.2", 3000); // <-- metti IP del COMPUTER
    setState(() => connected = true);

    socket!.listen((data) {
      setState(() {
        messages.add(utf8.decode(data).trim());
      });
    });
  }

  void sendMessage() {
    if (inputController.text.isEmpty) return;

    socket!.write(inputController.text + "\n");

    setState(() {
      messages.add("Tu: ${inputController.text}");
      inputController.clear();
    });
  }

  void sendUsername() {
    if (usernameController.text.isEmpty) return;

    socket!.write(usernameController.text.trim() + "\n");
    setState(() => usernameSent = true);
  }

  @override
  void dispose() {
    socket?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chatroom TCP")),
      body: connected == false
          ? Center(
              child: ElevatedButton(
                onPressed: connect,
                child: Text("Connetti al server"),
              ),
            )
          : usernameSent == false
              ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(labelText: "Username"),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: sendUsername,
                        child: Text("Entra nella chat"),
                      )
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (_, i) =>
                            ListTile(title: Text(messages[i])),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: inputController,
                            decoration: InputDecoration(hintText: "Messaggio"),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send),
                          onPressed: sendMessage,
                        )
                      ],
                    )
                  ],
                ),
    );
  }
}
