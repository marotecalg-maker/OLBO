import 'models/quiz_question.dart';

const List<QuizQuestion> kQuizQuestions = [
  // ── Easy ────────────────────────────────────────────────────────────────────
  QuizQuestion(
    question: 'How many players are on the field for one football team?',
    options: ['9', '10', '11', '12'],
    correctAnswer: 2,
    level: QuizLevel.easy,
  ),
  QuizQuestion(
    question: 'How long is a regular football match?',
    options: ['80 min', '90 min', '100 min', '120 min'],
    correctAnswer: 1,
    level: QuizLevel.easy,
  ),
  QuizQuestion(
    question: 'Which country won the 2022 FIFA World Cup?',
    options: ['France', 'Brazil', 'Argentina', 'Spain'],
    correctAnswer: 2,
    level: QuizLevel.easy,
  ),
  QuizQuestion(
    question: 'Which team is known as "The Red Devils"?',
    options: ['Liverpool', 'Arsenal', 'Manchester United', 'AC Milan'],
    correctAnswer: 2,
    level: QuizLevel.easy,
  ),
  QuizQuestion(
    question: 'What does VAR stand for?',
    options: [
      'Video Assistant Referee',
      'Virtual Action Replay',
      'Video Action Review',
      'Visual Assistance Rule',
    ],
    correctAnswer: 0,
    level: QuizLevel.easy,
  ),
  QuizQuestion(
    question: 'Which country invented the modern game of football?',
    options: ['France', 'Spain', 'England', 'Italy'],
    correctAnswer: 2,
    level: QuizLevel.easy,
  ),
  QuizQuestion(
    question: 'How many minutes are in each half of a standard match?',
    options: ['40', '45', '50', '60'],
    correctAnswer: 1,
    level: QuizLevel.easy,
  ),
  QuizQuestion(
    question: 'What colour card is shown for a straight sending off?',
    options: ['Yellow', 'Red', 'Blue', 'Orange'],
    correctAnswer: 1,
    level: QuizLevel.easy,
  ),
  QuizQuestion(
    question: 'What is it called when a player scores three goals in one match?',
    options: ['Double', 'Hat-trick', 'Triple', 'Treble'],
    correctAnswer: 1,
    level: QuizLevel.easy,
  ),
  QuizQuestion(
    question: 'Which of these is a position in football?',
    options: ['Blocker', 'Goalkeeper', 'Catcher', 'Guard'],
    correctAnswer: 1,
    level: QuizLevel.easy,
  ),
  QuizQuestion(
    question: 'How many teams play in a match?',
    options: ['2', '3', '4', '6'],
    correctAnswer: 0,
    level: QuizLevel.easy,
  ),
  QuizQuestion(
    question: 'What do you call a shot that goes into your own goal?',
    options: ['Penalty', 'Own goal', 'Free kick', 'Header'],
    correctAnswer: 1,
    level: QuizLevel.easy,
  ),

  // ── Medium ───────────────────────────────────────────────────────────────────
  QuizQuestion(
    question: 'Which club has won the most UEFA Champions League titles?',
    options: ['Barcelona', 'AC Milan', 'Bayern Munich', 'Real Madrid'],
    correctAnswer: 3,
    level: QuizLevel.medium,
  ),
  QuizQuestion(
    question: 'Which player has won the most Ballon d\'Or awards?',
    options: ['Cristiano Ronaldo', 'Zinedine Zidane', 'Lionel Messi', 'Ronaldinho'],
    correctAnswer: 2,
    level: QuizLevel.medium,
  ),
  QuizQuestion(
    question: 'In which year was FIFA founded?',
    options: ['1900', '1904', '1910', '1920'],
    correctAnswer: 1,
    level: QuizLevel.medium,
  ),
  QuizQuestion(
    question: 'Which country has won the most FIFA World Cup titles?',
    options: ['Germany', 'Italy', 'Argentina', 'Brazil'],
    correctAnswer: 3,
    level: QuizLevel.medium,
  ),
  QuizQuestion(
    question: 'What is the width of a standard football goal?',
    options: ['6.4 m', '7.32 m', '8.0 m', '7.0 m'],
    correctAnswer: 1,
    level: QuizLevel.medium,
  ),
  QuizQuestion(
    question: 'Which player scored the "Hand of God" goal in 1986?',
    options: ['Pelé', 'Ronaldo', 'Diego Maradona', 'Zinedine Zidane'],
    correctAnswer: 2,
    level: QuizLevel.medium,
  ),
  QuizQuestion(
    question: 'Which city hosted the 2018 FIFA World Cup final?',
    options: ['St. Petersburg', 'Sochi', 'Moscow', 'Kazan'],
    correctAnswer: 2,
    level: QuizLevel.medium,
  ),
  QuizQuestion(
    question: 'Which club did Cristiano Ronaldo join from Sporting CP?',
    options: ['Real Madrid', 'Manchester United', 'Juventus', 'Manchester City'],
    correctAnswer: 1,
    level: QuizLevel.medium,
  ),
  QuizQuestion(
    question: 'Which nation hosted the first ever FIFA World Cup in 1930?',
    options: ['Brazil', 'Argentina', 'Uruguay', 'Italy'],
    correctAnswer: 2,
    level: QuizLevel.medium,
  ),
  QuizQuestion(
    question: 'What is the offside rule based on?',
    options: [
      'Being behind the ball',
      'Being closer to goal than the last defender',
      'Being in the penalty area',
      'Being ahead of the midfield line',
    ],
    correctAnswer: 1,
    level: QuizLevel.medium,
  ),
  QuizQuestion(
    question: 'How many times has Brazil won the FIFA World Cup?',
    options: ['3', '4', '5', '6'],
    correctAnswer: 2,
    level: QuizLevel.medium,
  ),
  QuizQuestion(
    question: 'Which team won the 2020 UEFA Champions League?',
    options: ['PSG', 'Bayern Munich', 'Chelsea', 'Real Madrid'],
    correctAnswer: 1,
    level: QuizLevel.medium,
  ),

  // ── Hard ─────────────────────────────────────────────────────────────────────
  QuizQuestion(
    question: 'How many seconds can a goalkeeper hold the ball before releasing it?',
    options: ['4 seconds', '6 seconds', '8 seconds', '10 seconds'],
    correctAnswer: 1,
    level: QuizLevel.hard,
  ),
  QuizQuestion(
    question: 'Who holds the record for most goals in a single World Cup tournament?',
    options: ['Ronaldo', 'Pelé', 'Just Fontaine', 'Gerd Müller'],
    correctAnswer: 2,
    level: QuizLevel.hard,
  ),
  QuizQuestion(
    question: 'How many goals did Just Fontaine score at the 1958 World Cup?',
    options: ['11', '12', '13', '15'],
    correctAnswer: 2,
    level: QuizLevel.hard,
  ),
  QuizQuestion(
    question: 'What is the height of a standard football goal?',
    options: ['2.0 m', '2.24 m', '2.44 m', '2.60 m'],
    correctAnswer: 2,
    level: QuizLevel.hard,
  ),
  QuizQuestion(
    question: 'What is the maximum number of substitutions allowed in a standard match?',
    options: ['3', '4', '5', '6'],
    correctAnswer: 2,
    level: QuizLevel.hard,
  ),
  QuizQuestion(
    question: 'What is the penalty spot distance from the goal line?',
    options: ['10 yards', '11 yards', '12 yards', '16 yards'],
    correctAnswer: 2,
    level: QuizLevel.hard,
  ),
  QuizQuestion(
    question: 'Which player has scored the most goals in a single La Liga season?',
    options: ['Cristiano Ronaldo', 'Lionel Messi', 'Luis Suárez', 'Karim Benzema'],
    correctAnswer: 1,
    level: QuizLevel.hard,
  ),
  QuizQuestion(
    question: 'In what year did Pelé win his first FIFA World Cup?',
    options: ['1954', '1958', '1962', '1966'],
    correctAnswer: 1,
    level: QuizLevel.hard,
  ),
  QuizQuestion(
    question: 'How many stitches does a standard football have?',
    options: ['20', '28', '32', '36'],
    correctAnswer: 2,
    level: QuizLevel.hard,
  ),
  QuizQuestion(
    question: 'Which country won the first Women\'s FIFA World Cup in 1991?',
    options: ['Germany', 'Norway', 'USA', 'Sweden'],
    correctAnswer: 2,
    level: QuizLevel.hard,
  ),
];
