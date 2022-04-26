class Question {
  late final String question;
  late final List answersChoices;

  Question({required this.question, required this.answersChoices});

  String getQuestion() {
    return question;
  }

  List getAnswerChoices() {
    return answersChoices;
  }
}
