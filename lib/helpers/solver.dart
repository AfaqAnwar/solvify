class Solver {
  late String bodyText;
  late String question;
  late String answer;
  late String confidence;

  Solver() {
    bodyText = "";
    question = "";
    answer = "";
    confidence = "";
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

  String getConfidence() {
    return confidence;
  }

  void setConfidenceFromAnswer() {
    confidence = answer.substring(answer.indexOf("Confidence: ") + 12);
  }

  void parseAnswer() {
    answer = answer.substring(0, answer.indexOf("Confidence: "));
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

  void setConfidence(String confidence) {
    this.confidence = confidence;
  }

  double getConfidenceAsDouble() {
    return double.parse(confidence.substring(0, confidence.indexOf("%"))) / 100;
  }
}
