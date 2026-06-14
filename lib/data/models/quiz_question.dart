enum QuizLevel { easy, medium, hard }

extension QuizLevelExt on QuizLevel {
  String get label {
    switch (this) {
      case QuizLevel.easy:   return 'Easy';
      case QuizLevel.medium: return 'Medium';
      case QuizLevel.hard:   return 'Hard';
    }
  }

  String get emoji {
    switch (this) {
      case QuizLevel.easy:   return '🟢';
      case QuizLevel.medium: return '🟡';
      case QuizLevel.hard:   return '🔴';
    }
  }

  int get seconds {
    switch (this) {
      case QuizLevel.easy:   return 30;
      case QuizLevel.medium: return 20;
      case QuizLevel.hard:   return 15;
    }
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final QuizLevel level;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.level,
  });
}
