import 'dart:async';
import 'package:flutter/material.dart';

class GameTimer extends StatefulWidget {
  final DateTime startTime;

  const GameTimer({Key? key, required this.startTime}) : super(key: key);

  @override
  _GameTimerState createState() => _GameTimerState();
}

class _GameTimerState extends State<GameTimer> {
  late Timer _timer;
  Duration _elapsedTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime = DateTime.now().difference(widget.startTime);
      });
    });
  }

  String _formatTime(Duration duration) {
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer.cancel(); // Stop timer when widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatTime(_elapsedTime),
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: const Color.fromARGB(255, 26, 20, 78),
      ),
    );
  }
}
