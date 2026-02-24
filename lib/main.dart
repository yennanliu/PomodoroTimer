import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const PomodoroApp());
}

/// Root application widget with Material 3 theme
class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro Timer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE57373), // Soft red
          brightness: Brightness.light,
        ),
      ),
      home: const PomodoroTimer(),
    );
  }
}

/// Main Pomodoro Timer widget with state management
class PomodoroTimer extends StatefulWidget {
  const PomodoroTimer({super.key});

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  // Constants
  static const int _pomodoroMinutes = 25;
  static const int _totalSeconds = _pomodoroMinutes * 60; // 1500 seconds

  // State variables
  int _remainingSeconds = _totalSeconds;
  bool _isRunning = false;
  Timer? _timer;

  /// Formats seconds into MM:SS format
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  /// Starts the countdown timer
  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
    });

    // Create a periodic timer that ticks every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          // Timer finished - auto-reset to 25 minutes
          _timer?.cancel();
          _isRunning = false;
          _remainingSeconds = _totalSeconds;
        }
      });
    });
  }

  /// Pauses the countdown timer
  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  /// Resets the timer to 25 minutes
  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _remainingSeconds = _totalSeconds;
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Clean up timer when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine color based on timer state
    final timerColor = _isRunning
        ? const Color(0xFFE57373) // Soft red when running
        : Colors.grey.shade400; // Light grey when inactive

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Pomodoro Timer'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pomodoro icon
            Icon(
              Icons.access_time_rounded,
              size: 80,
              color: timerColor.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 40),

            // Timer display with smooth animation
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: animation,
                    child: child,
                  ),
                );
              },
              child: Text(
                _formatTime(_remainingSeconds),
                key: ValueKey<int>(_remainingSeconds),
                style: TextStyle(
                  fontSize: 96,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 8,
                  color: timerColor,
                  fontFeatures: const [
                    FontFeature.tabularFigures(), // Monospace numbers
                  ],
                ),
              ),
            ),

            const SizedBox(height: 60),

            // Control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Start/Pause button
                FilledButton.icon(
                  onPressed: _isRunning ? _pauseTimer : _startTimer,
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  label: Text(_isRunning ? 'Pause' : 'Start'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 20,
                    ),
                    backgroundColor: _isRunning
                        ? colorScheme.secondary
                        : colorScheme.primary,
                  ),
                ),

                const SizedBox(width: 20),

                // Reset button
                OutlinedButton.icon(
                  onPressed: _resetTimer,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 20,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Status text
            AnimatedOpacity(
              opacity: _remainingSeconds == 0 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '🎉 Pomodoro Completed!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
