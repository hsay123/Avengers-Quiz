import 'package:flutter_test/flutter_test.dart';
import '../lib/services/quiz_calculator.dart';
import '../lib/models/quiz_models.dart';
import '../lib/data/character_data.dart';

void main() {
  group('QuizCalculator', () {
    test('calculateWinner returns captain_america for discipline-heavy answers',
        () {
      final selections = [
        SelectedAnswer(
          questionId: 1,
          selectedOption: 'B',
          weights: {'captain_america': 1},
        ),
        SelectedAnswer(
          questionId: 2,
          selectedOption: 'B',
          weights: {'captain_america': 1},
        ),
        SelectedAnswer(
          questionId: 3,
          selectedOption: 'B',
          weights: {'captain_america': 1},
        ),
      ];

      final winnerId = QuizCalculator.calculateWinner(
        selections: selections,
        characters: CharacterData.characters,
      );

      expect(winnerId, 'captain_america');
    });

    test('calculateWinner returns iron_man for tech-heavy answers', () {
      final selections = [
        SelectedAnswer(
          questionId: 1,
          selectedOption: 'A',
          weights: {'iron_man': 1},
        ),
        SelectedAnswer(
          questionId: 2,
          selectedOption: 'A',
          weights: {'iron_man': 1},
        ),
        SelectedAnswer(
          questionId: 3,
          selectedOption: 'A',
          weights: {'iron_man': 1},
        ),
      ];

      final winnerId = QuizCalculator.calculateWinner(
        selections: selections,
        characters: CharacterData.characters,
      );

      expect(winnerId, 'iron_man');
    });

    test('calculateWinner returns hulk for strength-heavy answers', () {
      final selections = [
        SelectedAnswer(
          questionId: 1,
          selectedOption: 'D',
          weights: {'hulk': 1},
        ),
        SelectedAnswer(
          questionId: 2,
          selectedOption: 'D',
          weights: {'hulk': 1},
        ),
        SelectedAnswer(
          questionId: 3,
          selectedOption: 'D',
          weights: {'hulk': 1},
        ),
      ];

      final winnerId = QuizCalculator.calculateWinner(
        selections: selections,
        characters: CharacterData.characters,
      );

      expect(winnerId, 'hulk');
    });

    test('calculateWinner handles ties by preferring character order', () {
      final selections = [
        SelectedAnswer(
          questionId: 1,
          selectedOption: 'A',
          weights: {'iron_man': 1},
        ),
        SelectedAnswer(
          questionId: 2,
          selectedOption: 'B',
          weights: {'captain_america': 1},
        ),
      ];

      final winnerId = QuizCalculator.calculateWinner(
        selections: selections,
        characters: CharacterData.characters,
      );

      // Iron Man appears first in our character order, so should win ties
      expect(winnerId, 'iron_man');
    });

    test('calculateWinner throws StateError when no selections provided', () {
      expect(
        () => QuizCalculator.calculateWinner(
          selections: [],
          characters: CharacterData.characters,
        ),
        throwsStateError,
      );
    });

    test('createSelectionsFromAnswers converts answers correctly', () {
      final selectedAnswers = {0: 'A', 1: 'B'};
      final quizQuestions = [
        {
          'id': 1,
          'character_weights': {'A': 'iron_man', 'B': 'captain_america'},
        },
        {
          'id': 2,
          'character_weights': {'A': 'thor', 'B': 'hulk'},
        },
      ];

      final selections = QuizCalculator.createSelectionsFromAnswers(
        selectedAnswers: selectedAnswers,
        quizQuestions: quizQuestions,
      );

      expect(selections.length, 2);
      expect(selections[0].weights['iron_man'], 1);
      expect(selections[1].weights['hulk'], 1);
    });

    test('calculateQuizResult returns complete result', () {
      final selectedAnswers = {0: 'A', 1: 'A'};
      final quizQuestions = [
        {
          'id': 1,
          'character_weights': {'A': 'iron_man', 'B': 'captain_america'},
        },
        {
          'id': 2,
          'character_weights': {'A': 'iron_man', 'B': 'hulk'},
        },
      ];

      final result = QuizCalculator.calculateQuizResult(
        selectedAnswers: selectedAnswers,
        quizQuestions: quizQuestions,
      );

      expect(result.character.id, 'iron_man');
      expect(result.scores['iron_man'], 2);
      expect(result.totalQuestions, 2);
      expect(result.selections.length, 2);
    });
  });
}
