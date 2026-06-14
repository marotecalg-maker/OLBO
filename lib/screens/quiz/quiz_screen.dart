import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/quiz_question.dart';
import '../../data/quiz_data.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  static const int _questionsPerRound = 10;

  QuizLevel? _level;
  late List<QuizQuestion> _questions;
  int _current = 0;
  int _score = 0;
  int? _selected;
  bool _finished = false;

  void _pickLevel(QuizLevel level) {
    final pool = kQuizQuestions.where((q) => q.level == level).toList()
      ..shuffle(Random());
    setState(() {
      _level = level;
      _questions = pool.take(_questionsPerRound).toList();
      _current = 0;
      _score = 0;
      _selected = null;
      _finished = false;
    });
  }

  void _onAnswer(int index) {
    if (_selected != null) return;
    setState(() {
      _selected = index;
      if (index == _questions[_current].correctAnswer) _score++;
    });
  }

  void _onTimeout() {
    if (_selected != null) return;
    setState(() => _selected = -1); // -1 = timed out (no selection)
  }

  void _next() {
    if (_current + 1 >= _questions.length) {
      setState(() => _finished = true);
    } else {
      setState(() {
        _current++;
        _selected = null;
      });
    }
  }

  void _restart() => setState(() {
        _level = null;
        _finished = false;
        _selected = null;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Football Quiz'),
        automaticallyImplyLeading: false,
        actions: [
          if (_level != null && !_finished)
            TextButton(
              onPressed: _restart,
              child: Text(
                'Quit',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _level == null
            ? _LevelSelectView(
                key: const ValueKey('levels'),
                onPick: _pickLevel,
              )
            : _finished
                ? _ResultView(
                    key: const ValueKey('result'),
                    score: _score,
                    total: _questions.length,
                    level: _level!,
                    onRestart: _restart,
                    onSameLevel: () => _pickLevel(_level!),
                  )
                : _QuizView(
                    key: ValueKey('$_level-$_current'),
                    question: _questions[_current],
                    current: _current,
                    total: _questions.length,
                    level: _level!,
                    selected: _selected,
                    onSelect: _onAnswer,
                    onNext: _next,
                    onTimeout: _onTimeout,
                  ),
      ),
    );
  }
}

// ── Level selection ───────────────────────────────────────────────────────────

class _LevelSelectView extends StatelessWidget {
  final ValueChanged<QuizLevel> onPick;
  const _LevelSelectView({super.key, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.sports_soccer, size: 64, color: AppColors.primary),
          const SizedBox(height: 16),
          Text(
            'Choose Your Level',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '10 questions per round. Timer shrinks with difficulty.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 36),
          _LevelCard(
            level: QuizLevel.easy,
            description: 'Basic rules & famous players',
            onTap: () => onPick(QuizLevel.easy),
          ),
          const SizedBox(height: 16),
          _LevelCard(
            level: QuizLevel.medium,
            description: 'History, stats & competitions',
            onTap: () => onPick(QuizLevel.medium),
          ),
          const SizedBox(height: 16),
          _LevelCard(
            level: QuizLevel.hard,
            description: 'Expert knowledge & exact records',
            onTap: () => onPick(QuizLevel.hard),
          ),
        ],
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final QuizLevel level;
  final String description;
  final VoidCallback onTap;

  const _LevelCard({
    required this.level,
    required this.description,
    required this.onTap,
  });

  Color get _color {
    switch (level) {
      case QuizLevel.easy:   return Colors.green;
      case QuizLevel.medium: return Colors.orange;
      case QuizLevel.hard:   return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _color.withValues(alpha: 0.4), width: 1.5),
        ),
        child: Row(
          children: [
            Text(level.emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    level.label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _color,
                        ),
                  ),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${level.seconds}s',
                style: TextStyle(
                  color: _color,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Quiz view with timer ──────────────────────────────────────────────────────

class _QuizView extends StatefulWidget {
  final QuizQuestion question;
  final int current;
  final int total;
  final QuizLevel level;
  final int? selected;
  final ValueChanged<int> onSelect;
  final VoidCallback onNext;
  final VoidCallback onTimeout;

  const _QuizView({
    super.key,
    required this.question,
    required this.current,
    required this.total,
    required this.level,
    required this.selected,
    required this.onSelect,
    required this.onNext,
    required this.onTimeout,
  });

  @override
  State<_QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<_QuizView> {
  late int _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remaining = widget.level.seconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_remaining <= 1) {
        _timer?.cancel();
        setState(() => _remaining = 0);
        widget.onTimeout();
      } else {
        setState(() => _remaining--);
      }
    });
  }

  @override
  void didUpdateWidget(_QuizView old) {
    super.didUpdateWidget(old);
    // Stop timer once answered
    if (widget.selected != null && old.selected == null) {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Color get _timerColor {
    final pct = _remaining / widget.level.seconds;
    if (pct > 0.5) return Colors.green;
    if (pct > 0.25) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final answered = widget.selected != null;
    final timedOut = widget.selected == -1;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress row
          Row(
            children: [
              Text(
                'Question ${widget.current + 1}/${widget.total}',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              // Timer badge
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _timerColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: _timerColor.withValues(alpha: 0.5), width: 1.2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timer_outlined, size: 13, color: _timerColor),
                    const SizedBox(width: 4),
                    Text(
                      '${_remaining}s',
                      style: TextStyle(
                        color: _timerColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: widget.current / widget.total,
              minHeight: 5,
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 20),

          // Timer progress ring
          Center(
            child: SizedBox(
              width: 56,
              height: 56,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: answered
                        ? 0
                        : _remaining / widget.level.seconds,
                    strokeWidth: 5,
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(_timerColor),
                  ),
                  Text(
                    answered ? '✓' : '$_remaining',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: _timerColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Question card
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            color: AppColors.primary.withValues(alpha: 0.08),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                widget.question.question,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Timed-out banner
          if (timedOut)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.4)),
                ),
                child: const Text(
                  '⏰ Time\'s up!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ),

          // Options
          ...List.generate(widget.question.options.length, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _OptionButton(
                label: widget.question.options[i],
                index: i,
                selected: widget.selected,
                correctAnswer: widget.question.correctAnswer,
                onTap: () => widget.onSelect(i),
              ),
            );
          }),

          const SizedBox(height: 4),

          // Next button
          AnimatedOpacity(
            opacity: answered ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: FilledButton.icon(
              onPressed: answered ? widget.onNext : null,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: Text(
                widget.current + 1 >= widget.total
                    ? 'See Results'
                    : 'Next Question',
              ),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Option button ─────────────────────────────────────────────────────────────

class _OptionButton extends StatelessWidget {
  final String label;
  final int index;
  final int? selected;
  final int correctAnswer;
  final VoidCallback onTap;

  const _OptionButton({
    required this.label,
    required this.index,
    required this.selected,
    required this.correctAnswer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final answered = selected != null;
    final isCorrect = index == correctAnswer;
    final isSelected = selected == index;

    Color borderColor;
    Color bgColor;
    Color textColor;
    Widget? trailing;

    if (!answered) {
      borderColor = Theme.of(context).dividerColor;
      bgColor = Theme.of(context).cardColor;
      textColor = Theme.of(context).textTheme.bodyLarge!.color!;
      trailing = null;
    } else if (isCorrect) {
      borderColor = Colors.green;
      bgColor = Colors.green.withValues(alpha: 0.1);
      textColor = Colors.green.shade700;
      trailing =
          const Icon(Icons.check_circle, color: Colors.green, size: 20);
    } else if (isSelected) {
      borderColor = Colors.red;
      bgColor = Colors.red.withValues(alpha: 0.1);
      textColor = Colors.red.shade700;
      trailing = const Icon(Icons.cancel, color: Colors.red, size: 20);
    } else {
      borderColor = Theme.of(context).dividerColor;
      bgColor = Theme.of(context).cardColor;
      textColor = Theme.of(context)
          .textTheme
          .bodyLarge!
          .color!
          .withValues(alpha: 0.35);
      trailing = null;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: InkWell(
        onTap: answered ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: textColor,
                        fontWeight:
                            isCorrect && answered ? FontWeight.w600 : null,
                      ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }
}

// ── Result view ───────────────────────────────────────────────────────────────

class _ResultView extends StatelessWidget {
  final int score;
  final int total;
  final QuizLevel level;
  final VoidCallback onRestart;
  final VoidCallback onSameLevel;

  const _ResultView({
    super.key,
    required this.score,
    required this.total,
    required this.level,
    required this.onRestart,
    required this.onSameLevel,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (score / total * 100).round();
    final perfect = pct == 100;
    final trophy = pct >= 80;

    final String message;
    final Color accentColor;
    if (pct == 100) {
      message = 'Perfect score! You\'re a football genius! 🔥';
      accentColor = Colors.amber;
    } else if (pct >= 80) {
      message = 'Great job! You really know your football!';
      accentColor = Colors.green;
    } else if (pct >= 50) {
      message = 'Not bad! Keep watching more matches.';
      accentColor = AppColors.primary;
    } else {
      message = 'Keep practicing — the beautiful game awaits!';
      accentColor = Colors.orange;
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                trophy ? Icons.emoji_events_rounded : Icons.sports_soccer,
                size: 52,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              perfect ? 'Perfect!' : 'Quiz Complete!',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              '${level.emoji} ${level.label} Level',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 24),
                child: Column(
                  children: [
                    Text(
                      '$score / $total',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: accentColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$pct% correct',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onSameLevel,
                icon: const Icon(Icons.replay_rounded),
                label: Text('Play Again (${level.label})'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onRestart,
                icon: const Icon(Icons.tune_rounded),
                label: const Text('Change Level'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
