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

  late List<QuizQuestion> _questions;
  int _current = 0;
  int _score = 0;
  int? _selected;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _startQuiz();
  }

  void _startQuiz() {
    final shuffled = List<QuizQuestion>.from(kQuizQuestions)..shuffle(Random());
    _questions = shuffled.take(_questionsPerRound).toList();
    _current = 0;
    _score = 0;
    _selected = null;
    _finished = false;
  }

  void _select(int index) {
    if (_selected != null) return;
    setState(() {
      _selected = index;
      if (index == _questions[_current].correctAnswer) _score++;
    });
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

  void _restart() {
    setState(_startQuiz);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Football Quiz'),
        automaticallyImplyLeading: false,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: _finished
            ? _ResultView(
                key: const ValueKey('result'),
                score: _score,
                total: _questions.length,
                onRestart: _restart,
              )
            : _QuizView(
                key: ValueKey(_current),
                question: _questions[_current],
                current: _current,
                total: _questions.length,
                selected: _selected,
                onSelect: _select,
                onNext: _next,
              ),
      ),
    );
  }
}

// ── Quiz view ─────────────────────────────────────────────────────────────────

class _QuizView extends StatelessWidget {
  final QuizQuestion question;
  final int current;
  final int total;
  final int? selected;
  final ValueChanged<int> onSelect;
  final VoidCallback onNext;

  const _QuizView({
    super.key,
    required this.question,
    required this.current,
    required this.total,
    required this.selected,
    required this.onSelect,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final answered = selected != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress
          Row(
            children: [
              Text(
                'Question ${current + 1}/$total',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text(
                '⚽ ${(((current) / total) * 100).round()}%',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (current) / total,
              minHeight: 6,
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 28),

          // Question card
          Card(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: AppColors.primary.withValues(alpha: 0.08),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                question.question,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Options
          ...List.generate(question.options.length, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _OptionButton(
                label: question.options[i],
                index: i,
                selected: selected,
                correctAnswer: question.correctAnswer,
                onTap: () => onSelect(i),
              ),
            );
          }),

          const SizedBox(height: 8),

          // Next button
          AnimatedOpacity(
            opacity: answered ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: FilledButton.icon(
              onPressed: answered ? onNext : null,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: Text(
                current + 1 >= total ? 'See Results' : 'Next Question',
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
      trailing = const Icon(Icons.check_circle, color: Colors.green, size: 20);
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
          .withValues(alpha: 0.4);
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
  final VoidCallback onRestart;

  const _ResultView({
    super.key,
    required this.score,
    required this.total,
    required this.onRestart,
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
            // Icon
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
            const SizedBox(height: 24),

            Text(
              perfect ? 'Perfect!' : 'Quiz Complete!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Score card
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                child: Column(
                  children: [
                    Text(
                      '$score / $total',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(
                              fontWeight: FontWeight.bold, color: accentColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$pct% correct',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onRestart,
                icon: const Icon(Icons.replay_rounded),
                label: const Text('Play Again'),
                style: FilledButton.styleFrom(
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
