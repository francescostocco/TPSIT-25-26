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
  StreamController<int>? _secondsController;

  int _milliseconds = 0;
  bool _running = false;
  bool _paused = false;

  Stream<int> _ticker() =>
      Stream.periodic(const Duration(milliseconds: 100), (tuck) => tuck);

  Stream<int> _seconds(Stream<int> ticker) =>
      ticker.where((tuck) => tuck % 10 == 0).map((tuck) => tuck ~/ 10);

  void _start() {
    _secondsController = StreamController<int>();

    final tickerStream = _ticker();

    _tickerSub = tickerStream.listen((tick) {
      if (!_paused) {
        setState(() => _milliseconds += 100);

        if (_milliseconds % 1000 == 0) {
          _secondsController?.add(_milliseconds ~/ 1000);
        }
      }
    });

    setState(() {
      _running = true;
      _paused = false;
    });
  }

  void _reset() {
    _tickerSub?.cancel();
    _secondsController?.close();
    setState(() {
      _milliseconds = 0;
      _running = false;
      _paused = false;
    });
  }

  void _togglePause() {
    setState(() => _paused = !_paused);
  }

  @override
  void dispose() {
    _tickerSub?.cancel();
    _secondsController?.close();
    super.dispose();
  }

  String _formatTime(int ms) {
    int totalSeconds = ms ~/ 1000;
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    int decimi = (ms % 1000) ~/ 100;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}.'
        '$decimi';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chrono")),
      body: Center(
        child: StreamBuilder<int>(
          stream: _secondsController?.stream, 
          builder: (context, snapshot) {
            return Text(
              _formatTime(_milliseconds),
              style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            );
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "start_reset",
            onPressed: !_running ? _start : _reset,
            child: Icon(!_running ? Icons.play_arrow : Icons.refresh),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: "pause_resume",
            onPressed: _running ? _togglePause : null,
            backgroundColor: _running ? Colors.blue : Colors.grey,
            child: Icon(_paused ? Icons.play_arrow : Icons.pause),
          ),
        ],
      ),
    );
  }
}
