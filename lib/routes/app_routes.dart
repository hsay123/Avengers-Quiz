import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/character_gallery_screen/character_gallery_screen.dart';
import '../presentation/quiz_results_screen/quiz_results_screen.dart';
import '../presentation/welcome_screen/welcome_screen.dart';
import '../presentation/quiz_question_screen/quiz_question_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String characterGallery = '/character-gallery-screen';
  static const String quizResults = '/quiz-results-screen';
  static const String welcome = '/welcome-screen';
  static const String quizQuestion = '/quiz-question-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    characterGallery: (context) => const CharacterGalleryScreen(),
    quizResults: (context) => const QuizResultsScreen(),
    welcome: (context) => const WelcomeScreen(),
    quizQuestion: (context) => const QuizQuestionScreen(),
    // TODO: Add your other routes here
  };
}
