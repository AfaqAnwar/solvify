class Solver {
  late String bodyText;
  late String question;
  late String answer;

  Solver() {
    bodyText = "";
    question = "";
    answer = "";
  }

  String getBodyText() {
    return bodyText;
  }

  String getQuestion() {
    return question;
  }

  String getAnswer() {
    return answer;
  }

  void setBodyText(String bodyText) {
    this.bodyText = bodyText;
  }

  void setQuestion(String question) {
    this.question = question;
  }

  void setAnswer(String answer) {
    this.answer = answer;
  }
}
