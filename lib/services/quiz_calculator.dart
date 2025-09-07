import '../models/quiz_models.dart';
import '../data/character_data.dart';

class QuizCalculator {
  /// Calculates the winner character based on quiz selections
  /// Throws StateError if no answers are provided
  static String calculateWinner({
    required List<SelectedAnswer> selections,
    required Map<String, Character> characters,
  }) {
    if (selections.isEmpty) {
      throw StateError('No answers selected');
    }

    final scores = <String, int>{};

    // Calculate scores for each character
    for (final selection in selections) {
      selection.weights.forEach((charId, weight) {
        scores[charId] = (scores[charId] ?? 0) + weight;
      });
    }

    if (scores.isEmpty) {
      throw StateError('No valid character weights found');
    }

    // Find the character with the highest score
    // In case of tie, prefer the one that appears first in our character map
    String? winnerId;
    int maxScore = -1;

    // Get character priority order for consistent tie-breaking
    final characterOrder =
        CharacterData.getAllCharacters().map((c) => c.id).toList();

    for (final charId in characterOrder) {
      final score = scores[charId] ?? 0;
      if (score > maxScore) {
        maxScore = score;
        winnerId = charId;
      }
    }

    if (winnerId == null) {
      // Fallback - should never happen with proper data
      winnerId =
          scores.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
    }

    return winnerId;
  }

  /// Creates selected answers from quiz questions and user selections
  static List<SelectedAnswer> createSelectionsFromAnswers({
    required Map<int, String> selectedAnswers,
    required List<Map<String, dynamic>> quizQuestions,
  }) {
    final selections = <SelectedAnswer>[];

    selectedAnswers.forEach((questionIndex, selectedOption) {
      if (questionIndex < quizQuestions.length) {
        final question = quizQuestions[questionIndex];
        final characterWeights =
            question['character_weights'] as Map<String, dynamic>;

        // Get the character that corresponds to the selected option
        final selectedCharacter = characterWeights[selectedOption] as String?;

        if (selectedCharacter != null) {
          // Create weight map with 1 point for the selected character
          final weights = <String, int>{selectedCharacter: 1};

          selections.add(SelectedAnswer(
            questionId: question['id'] as int,
            selectedOption: selectedOption,
            weights: weights,
          ));
        }
      }
    });

    return selections;
  }

  /// Calculates complete quiz result
  static QuizResult calculateQuizResult({
    required Map<int, String> selectedAnswers,
    required List<Map<String, dynamic>> quizQuestions,
  }) {
    final selections = createSelectionsFromAnswers(
      selectedAnswers: selectedAnswers,
      quizQuestions: quizQuestions,
    );

    final scores = <String, int>{};
    for (final selection in selections) {
      selection.weights.forEach((charId, weight) {
        scores[charId] = (scores[charId] ?? 0) + weight;
      });
    }

    final winnerId = calculateWinner(
      selections: selections,
      characters: CharacterData.characters,
    );

    final winnerCharacter = CharacterData.getCharacterById(winnerId);
    if (winnerCharacter == null) {
      throw StateError('Winner character not found: $winnerId');
    }

    return QuizResult(
      character: winnerCharacter,
      scores: scores,
      totalQuestions: quizQuestions.length,
      selections: selections,
    );
  }
}
