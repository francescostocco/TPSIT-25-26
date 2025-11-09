import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StopWatchPage(),
    ));

class StopWatchPage extends StatefulWidget {
  const StopWatchPage({super.key});

  @override
  State<StopWatchPage> createState() => _StopWatchPageState();
}

class _StopWatchPageState extends State<StopWatchPage> {
  StreamSubscription<int>? _tickerSub;
  final StreamController<int> _secondsController = StreamController<int>.broadcast();

  int _seconds = 0;
  bool _running = false;
  bool _paused = false;

  Stream<int> _ticker() =>
      Stream.periodic(const Duration(milliseconds: 100), (tuck) => tuck);

  Stream<int> _secondsStream(Stream<int> ticker) =>
      ticker.where((tuck) => tuck % 10 == 0).map((tuck) => tuck ~/ 10);

  void _start() {
    if (!_running) {
      final tickerStream = _ticker();
      final secondsStream = _secondsStream(tickerStream);

      _tickerSub = secondsStream.listen((seconds) {
        if (!_paused) {
          setState(() {
            _seconds += 1; 
          });
          _secondsController.add(_seconds);
        }
      });

      setState(() {
        _running = true;
        _paused = false;
      });
    } else {
      _reset();
    }
  }

  void _pauseResume() {
    if (_running) {
      setState(() {
        _paused = !_paused;
      });
    }
  }

  void _reset() {
    _tickerSub?.cancel();
    setState(() {
      _running = false;
      _paused = false;
      _seconds = 0;
    });
    _secondsController.add(_seconds);
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _tickerSub?.cancel();
    _secondsController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chrono")),
      body: Center(
        child: StreamBuilder<int>(
          stream: _secondsController.stream,
          initialData: _seconds,
          builder: (context, snapshot) {
            final time = _formatTime(snapshot.data ?? 0);
            return Text(
              time,
              style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            );
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _start,
            child: Icon(_running ? Icons.stop : Icons.play_arrow),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: _pauseResume,
            child: Icon(_paused ? Icons.play_arrow : Icons.pause),
          ),
        ],
      ),
    );
  }
}
