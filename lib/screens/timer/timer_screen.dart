import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

enum _TimerMode { stopwatch, countdown }

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with SingleTickerProviderStateMixin {
  _TimerMode _mode = _TimerMode.stopwatch;

  // Stopwatch
  final Stopwatch _stopwatch = Stopwatch();
  Duration _elapsed = Duration.zero;

  // Countdown
  static const _presets = [5, 10, 45, 90];
  int _countdownMinutes = 45;
  Duration _remaining = const Duration(minutes: 45);
  bool _countdownFinished = false;

  Timer? _ticker;

  bool get _running => _ticker != null && _ticker!.isActive;

  void _startStop() {
    if (_running) {
      _ticker?.cancel();
      if (_mode == _TimerMode.stopwatch) _stopwatch.stop();
      setState(() {});
    } else {
      if (_mode == _TimerMode.stopwatch) {
        _stopwatch.start();
      } else {
        if (_remaining == Duration.zero) return;
        _countdownFinished = false;
      }
      _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) {
        setState(() {
          if (_mode == _TimerMode.stopwatch) {
            _elapsed = _stopwatch.elapsed;
          } else {
            final now = Duration(
              milliseconds: _remaining.inMilliseconds - 100,
            );
            if (now <= Duration.zero) {
              _remaining = Duration.zero;
              _countdownFinished = true;
              _ticker?.cancel();
            } else {
              _remaining = now;
            }
          }
        });
      });
      setState(() {});
    }
  }

  void _reset() {
    _ticker?.cancel();
    _stopwatch.reset();
    setState(() {
      _elapsed = Duration.zero;
      _remaining = Duration(minutes: _countdownMinutes);
      _countdownFinished = false;
    });
  }

  void _switchMode(_TimerMode mode) {
    if (_running) _ticker?.cancel();
    _stopwatch.reset();
    setState(() {
      _mode = mode;
      _elapsed = Duration.zero;
      _remaining = Duration(minutes: _countdownMinutes);
      _countdownFinished = false;
    });
  }

  void _setPreset(int minutes) {
    if (_running) _ticker?.cancel();
    setState(() {
      _countdownMinutes = minutes;
      _remaining = Duration(minutes: minutes);
      _countdownFinished = false;
    });
  }

  String _fmt(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (h > 0) return '$h:$m:$s';
    return '$m:$s';
  }

  double get _progress {
    if (_mode == _TimerMode.stopwatch) return 0;
    final total = Duration(minutes: _countdownMinutes).inMilliseconds;
    if (total == 0) return 0;
    return 1 - _remaining.inMilliseconds / total;
  }

  Color get _ringColor {
    if (_mode == _TimerMode.stopwatch) return AppColors.primary;
    if (_countdownFinished) return Colors.red;
    final pct = _remaining.inMilliseconds /
        Duration(minutes: _countdownMinutes).inMilliseconds;
    if (pct > 0.4) return AppColors.primary;
    if (pct > 0.15) return Colors.orange;
    return Colors.red;
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayTime = _mode == _TimerMode.stopwatch
        ? _fmt(_elapsed)
        : _fmt(_remaining);

    return Scaffold(
      appBar: AppBar(title: const Text('Toilet Timer')),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Mode toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: _ModeButton(
                    label: 'Stopwatch',
                    icon: Icons.timer_outlined,
                    active: _mode == _TimerMode.stopwatch,
                    onTap: () => _switchMode(_TimerMode.stopwatch),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ModeButton(
                    label: 'Countdown',
                    icon: Icons.hourglass_bottom_rounded,
                    active: _mode == _TimerMode.countdown,
                    onTap: () => _switchMode(_TimerMode.countdown),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Big clock ring
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 240,
                    height: 240,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox.expand(
                          child: CircularProgressIndicator(
                            value: _mode == _TimerMode.stopwatch
                                ? null
                                : _progress,
                            strokeWidth: 8,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(_ringColor),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_countdownFinished)
                              const Text('⏰',
                                  style: TextStyle(fontSize: 32))
                            else
                              Icon(
                                _running
                                    ? Icons.sports_soccer
                                    : Icons.timer_outlined,
                                color: _ringColor,
                                size: 28,
                              ),
                            const SizedBox(height: 8),
                            Text(
                              displayTime,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 52,
                                    color: _countdownFinished
                                        ? Colors.red
                                        : null,
                                    letterSpacing: 2,
                                  ),
                            ),
                            if (_countdownFinished) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Time\'s up!',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Presets (countdown only)
                  if (_mode == _TimerMode.countdown) ...[
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _presets.map((min) {
                        final selected = min == _countdownMinutes;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: ChoiceChip(
                            label: Text('${min}m'),
                            selected: selected,
                            onSelected: (_) => _setPreset(min),
                            selectedColor:
                                AppColors.primary.withValues(alpha: 0.2),
                            labelStyle: TextStyle(
                              color: selected ? AppColors.primary : null,
                              fontWeight: selected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Reset
                      IconButton.outlined(
                        onPressed: _reset,
                        icon: const Icon(Icons.replay_rounded),
                        iconSize: 28,
                        padding: const EdgeInsets.all(14),
                        style: IconButton.styleFrom(
                          side: BorderSide(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      // Start / Pause
                      GestureDetector(
                        onTap: _startStop,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: _running
                                ? Colors.orange
                                : AppColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (_running
                                        ? Colors.orange
                                        : AppColors.primary)
                                    .withValues(alpha: 0.4),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            _running
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 38,
                          ),
                        ),
                      ),
                      // Spacer to balance layout
                      const SizedBox(width: 24),
                      const SizedBox(width: 56),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _ModeButton({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: active
              ? AppColors.primary.withValues(alpha: 0.12)
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active
                ? AppColors.primary.withValues(alpha: 0.5)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 18,
                color: active ? AppColors.primary : Colors.grey),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: active ? AppColors.primary : Colors.grey,
                fontWeight:
                    active ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
