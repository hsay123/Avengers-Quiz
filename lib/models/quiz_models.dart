class SelectedAnswer {
  final int questionId;
  final String selectedOption;
  final Map<String, int> weights;

  SelectedAnswer({
    required this.questionId,
    required this.selectedOption,
    required this.weights,
  });

  @override
  String toString() =>
      'SelectedAnswer(questionId: $questionId, selectedOption: $selectedOption, weights: $weights)';
}

class Character {
  final String id;
  final String name;
  final String avatar;
  final String description;
  final List<String> traits;
  final List<String> strengths;
  final List<String> funFacts;

  Character({
    required this.id,
    required this.name,
    required this.avatar,
    required this.description,
    required this.traits,
    required this.strengths,
    required this.funFacts,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'description': description,
      'traits': traits,
      'strengths': strengths,
      'funFacts': funFacts,
    };
  }
}

class QuizResult {
  final Character character;
  final Map<String, int> scores;
  final int totalQuestions;
  final List<SelectedAnswer> selections;

  QuizResult({
    required this.character,
    required this.scores,
    required this.totalQuestions,
    required this.selections,
  });
}
