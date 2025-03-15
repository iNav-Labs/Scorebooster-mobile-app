// import 'package:flutter/material.dart';
// import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

// class TimerCountdownWrapper extends StatefulWidget {
//   @override
//   _TimerCountdownWrapperState createState() => _TimerCountdownWrapperState();
// }

// class _TimerCountdownWrapperState extends State<TimerCountdownWrapper> {
//   Color _backgroundColor = Colors.blue;
//   bool _isBlinking = false;

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // Background Container
//         Container(
//           color: _backgroundColor,
//           height: 10,
//           width: 70,
//         ),
//         // TimerCountdown Widget
//         Center(
//           child: TimerCountdown(
//             enableDescriptions: false,
//             format: CountDownTimerFormat.hoursMinutesSeconds,
//             timeTextStyle: TextStyle(
//               fontSize: 18,
//               color: Colors.black, // Ensure text is visible on the background
//             ),
//             endTime: DateTime.now().add(
//               const Duration(minutes: 1, seconds: 10),
//             ),
//             onEnd: () {
//               // Handle timer end
//             },
//             onTick: (remainingTime) {
//               if (remainingTime.inSeconds <= 60) {
//                 // Blinking red when 1 minute or less is left
//                 setState(() {
//                   _isBlinking = !_isBlinking;
//                   _backgroundColor = _isBlinking
//                       ? Colors.red
//                       : Colors.red[300]!; // Toggle between red and light red
//                 });
//               } else if (remainingTime.inMinutes < 5) {
//                 // Solid red when 5 minutes or less is left
//                 if (_backgroundColor != Colors.red) {
//                   setState(() {
//                     _backgroundColor = Colors.red;
//                   });
//                 }
//               } else {
//                 // Blue when more than 5 minutes are left
//                 if (_backgroundColor != Colors.blue) {
//                   setState(() {
//                     _backgroundColor = Colors.blue;
//                   });
//                 }
//               }
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final int durationInMinutes;

  const CountdownTimer({
    super.key,
    required this.durationInMinutes,
    required this.onTimerEnd,
  });
  final VoidCallback onTimerEnd;

  @override
  // ignore: library_private_types_in_public_api
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  late int _remainingSeconds;
  late AnimationController _blinkController;
  bool _isVisible = true;
  bool page_loaded = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationInMinutes * 60;

    // Setup blinking animation controller
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _blinkController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _isVisible = false);
        _blinkController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        setState(() => _isVisible = true);
        _blinkController.forward();
      }
    });

    // Start the countdown timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;

          // Start blinking if less than 1 minute remains
          if (_remainingSeconds <= 60 && !_blinkController.isAnimating) {
            _blinkController.forward();
          }
        } else {
          _timer.cancel();
          _blinkController.stop();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _blinkController.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Color _getTimerColor() {
    if (_remainingSeconds <= 0) {
      if (!page_loaded) {
        page_loaded = true;

        widget.onTimerEnd();
      }
    } //TODO add the submit function here
    if (_remainingSeconds <= 60) {
      return Colors.redAccent;
    } else if (_remainingSeconds <= 300) {
      // 5 minutes
      return Colors.redAccent;
    }
    return Colors.blue[400]!;
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _remainingSeconds <= 60 ? (_isVisible ? 1.0 : 0.3) : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: _getTimerColor(),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _getTimerColor(),
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: Text(
            _formatTime(_remainingSeconds),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
