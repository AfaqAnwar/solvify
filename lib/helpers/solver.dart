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
    // Use a regular expression to capture all confidence percentages in the response
    RegExp confidenceExp = RegExp(r'Confidence: (\d+)%');
    Iterable<Match> matches = confidenceExp.allMatches(answer);

    int sum = 0;
    int count = 0;

    for (Match match in matches) {
      sum += int.parse(
          match.group(1)!); // Add the confidence percentage to the sum
      count++; // Increment the number of confidences found
    }

    if (count > 0) {
      int averageConfidence = (sum / count).round();
      confidence = '$averageConfidence%';
    } else {
      confidence = '0%';
    }
  }

  void parseAnswer() {
    // First, remove all confidence portions from the string
    String withoutConfidence =
        answer.replaceAll(RegExp(r'Confidence: \d+%'), '').trim();

    // Split the result by lines and remove any empty lines
    List<String> lines = withoutConfidence
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();

    // Join the answer lines back together to form the final parsed answer
    String parsedAnswer = lines.join('\n').trim();

    answer = parsedAnswer;
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
