import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/quiz_calculator.dart';
import './widgets/answer_option_widget.dart';
import './widgets/navigation_controls_widget.dart';
import './widgets/question_card_widget.dart';
import './widgets/question_progress_widget.dart';

class QuizQuestionScreen extends StatefulWidget {
  const QuizQuestionScreen({Key? key}) : super(key: key);

  @override
  State<QuizQuestionScreen> createState() => _QuizQuestionScreenState();
}

class _QuizQuestionScreenState extends State<QuizQuestionScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _slideAnimationController;
  late Animation<Offset> _slideAnimation;

  int _currentQuestionIndex = 0;
  Map<int, String> _selectedAnswers = {};
  bool _isAnimating = false;

  // Mock quiz data
  final List<Map<String, dynamic>> _quizQuestions = [
    {
      "id": 1,
      "question": "What motivates you most when facing a difficult challenge?",
      "options": {
        "A":
            "Using my intelligence and technology to find innovative solutions",
        "B": "Standing up for what's right, no matter the personal cost",
        "C": "Protecting those I care about with unwavering determination",
        "D": "Channeling my inner strength to overcome any obstacle"
      },
      "character_weights": {
        "A": "iron_man",
        "B": "captain_america",
        "C": "thor",
        "D": "hulk"
      }
    },
    {
      "id": 2,
      "question": "How do you prefer to work in a team environment?",
      "options": {
        "A": "As the strategic leader, coordinating everyone's efforts",
        "B": "As the moral compass, ensuring we do the right thing",
        "C": "As the reliable teammate who has everyone's back",
        "D": "As the specialist who handles the toughest situations"
      },
      "character_weights": {
        "A": "iron_man",
        "B": "captain_america",
        "C": "black_widow",
        "D": "hulk"
      }
    },
    {
      "id": 3,
      "question": "What's your greatest strength in battle?",
      "options": {
        "A": "Advanced technology and tactical planning",
        "B": "Unbreakable shield and unwavering resolve",
        "C": "Mystical powers and ancient wisdom",
        "D": "Raw power and unstoppable force"
      },
      "character_weights": {
        "A": "iron_man",
        "B": "captain_america",
        "C": "thor",
        "D": "hulk"
      }
    },
    {
      "id": 4,
      "question": "How do you handle making difficult decisions?",
      "options": {
        "A": "Analyze all data and calculate the best outcome",
        "B": "Follow my moral principles, even if it's harder",
        "C": "Trust my instincts and warrior's intuition",
        "D": "Let my emotions guide me to protect others"
      },
      "character_weights": {
        "A": "iron_man",
        "B": "captain_america",
        "C": "thor",
        "D": "hulk"
      }
    },
    {
      "id": 5,
      "question": "What's your ideal way to spend downtime?",
      "options": {
        "A": "Working on new inventions in my workshop",
        "B": "Training and staying physically prepared",
        "C": "Enjoying feasts and celebrating with friends",
        "D": "Finding peaceful solitude away from stress"
      },
      "character_weights": {
        "A": "iron_man",
        "B": "captain_america",
        "C": "thor",
        "D": "hulk"
      }
    },
    {
      "id": 6,
      "question": "How do you view your role as a hero?",
      "options": {
        "A": "Using my resources to protect the world through innovation",
        "B": "Being a symbol of hope and doing what's right",
        "C": "Defending the realms with honor and nobility",
        "D": "Controlling my power to help rather than harm"
      },
      "character_weights": {
        "A": "iron_man",
        "B": "captain_america",
        "C": "thor",
        "D": "hulk"
      }
    },
    {
      "id": 7,
      "question": "What's your biggest fear or weakness?",
      "options": {
        "A": "Losing control of my technology or failing those I protect",
        "B": "Compromising my values or letting down my team",
        "C": "Being unworthy of my power or disappointing my people",
        "D": "Hurting innocent people when I lose control"
      },
      "character_weights": {
        "A": "iron_man",
        "B": "captain_america",
        "C": "thor",
        "D": "hulk"
      }
    },
    {
      "id": 8,
      "question": "How do you approach learning new skills?",
      "options": {
        "A": "Through research, experimentation, and technological enhancement",
        "B": "Through disciplined practice and physical training",
        "C": "Through experience, tradition, and ancient knowledge",
        "D": "Through necessity and adapting to survive"
      },
      "character_weights": {
        "A": "iron_man",
        "B": "captain_america",
        "C": "thor",
        "D": "hulk"
      }
    },
    {
      "id": 9,
      "question": "What drives your sense of responsibility?",
      "options": {
        "A":
            "My wealth and intelligence give me the power to make a difference",
        "B": "With great power comes great responsibility to serve others",
        "C": "My royal heritage demands I protect all the realms",
        "D": "I must control my power to prevent causing harm"
      },
      "character_weights": {
        "A": "iron_man",
        "B": "captain_america",
        "C": "thor",
        "D": "hulk"
      }
    },
    {
      "id": 10,
      "question": "How do you want to be remembered?",
      "options": {
        "A": "As a genius who used technology to save the world",
        "B": "As someone who always stood up for what was right",
        "C": "As a worthy protector who brought honor to my people",
        "D": "As someone who learned to control their power for good"
      },
      "character_weights": {
        "A": "iron_man",
        "B": "captain_america",
        "C": "thor",
        "D": "hulk"
      }
    }
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _slideAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start slide animation
    _slideAnimationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _slideAnimationController.dispose();
    super.dispose();
  }

  void _selectAnswer(String optionKey) {
    if (_isAnimating) return;

    setState(() {
      _selectedAnswers[_currentQuestionIndex] = optionKey;
    });

    // Auto-advance after selection with delay
    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted && _selectedAnswers.containsKey(_currentQuestionIndex)) {
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    if (_isAnimating) return;

    if (_currentQuestionIndex < _quizQuestions.length - 1) {
      setState(() {
        _isAnimating = true;
        _currentQuestionIndex++;
      });

      _pageController
          .nextPage(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      )
          .then((_) {
        setState(() => _isAnimating = false);
      });
    } else {
      _finishQuiz();
    }
  }

  void _previousQuestion() {
    if (_isAnimating || _currentQuestionIndex == 0) return;

    setState(() {
      _isAnimating = true;
      _currentQuestionIndex--;
    });

    _pageController
        .previousPage(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    )
        .then((_) {
      setState(() => _isAnimating = false);
    });
  }

  void _finishQuiz() {
    try {
      // Calculate the actual quiz result
      final result = QuizCalculator.calculateQuizResult(
        selectedAnswers: _selectedAnswers,
        quizQuestions: _quizQuestions,
      );

      // Navigate to results screen with the calculated result
      Navigator.pushReplacementNamed(
        context,
        '/quiz-results-screen',
        arguments: result,
      );
    } catch (e) {
      // Handle error - show error message or fallback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error calculating quiz results. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  double get _progress => (_currentQuestionIndex + 1) / _quizQuestions.length;

  bool get _canGoNext => _selectedAnswers.containsKey(_currentQuestionIndex);

  bool get _canGoBack => _currentQuestionIndex > 0;

  bool get _isLastQuestion =>
      _currentQuestionIndex == _quizQuestions.length - 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'close',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: Text(
          'Avengers Quiz',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress Header
          QuestionProgressWidget(
            currentQuestion: _currentQuestionIndex + 1,
            totalQuestions: _quizQuestions.length,
            progress: _progress,
          ),

          // Question Content
          Expanded(
            child: SlideTransition(
              position: _slideAnimation,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  if (!_isAnimating) {
                    setState(() => _currentQuestionIndex = index);
                  }
                },
                itemCount: _quizQuestions.length,
                itemBuilder: (context, index) {
                  final question = _quizQuestions[index];
                  final options = question['options'] as Map<String, dynamic>;

                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: 2.h),

                        // Question Card
                        QuestionCardWidget(
                          question: question['question'] as String,
                          questionNumber: index + 1,
                        ),

                        SizedBox(height: 3.h),

                        // Answer Options
                        ...options.entries.map((entry) {
                          final optionIndex =
                              ['A', 'B', 'C', 'D'].indexOf(entry.key);
                          return AnswerOptionWidget(
                            optionText: entry.value as String,
                            optionKey: entry.key,
                            isSelected: _selectedAnswers[index] == entry.key,
                            onTap: () => _selectAnswer(entry.key),
                            index: optionIndex,
                          );
                        }).toList(),

                        SizedBox(height: 4.h),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // Navigation Controls
          NavigationControlsWidget(
            canGoBack: _canGoBack,
            canGoNext: _canGoNext,
            onBack: _previousQuestion,
            onNext: _nextQuestion,
            isLastQuestion: _isLastQuestion,
          ),
        ],
      ),
    );
  }
}
