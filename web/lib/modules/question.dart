class Question {
  late final String category;
  late final String question;
  late final String correctAnswer;
  late final List answersChoices;

  Question(
      {required this.category,
      required this.question,
      required this.correctAnswer,
      required this.answersChoices});

  String getCategory() {
    return category;
  }

  String getQuestion() {
    return question;
  }

  String getAnswer() {
    return correctAnswer;
  }

  List getAnswerChoices() {
    return answersChoices;
  }
}
