import 'dart:math';
import 'dart:convert';
import 'package:flutter/services.dart';

// ── Question Model ────────────────────────────────────────────────────────────
class Question {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String subject;
  final int year;

  const Question({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.subject,
    required this.year,
  });

  // Parse from JSON map
  factory Question.fromJson(Map<String, dynamic> json, String subject) {
    return Question(
      question:     json['question'] as String,
      options:      List<String>.from(json['options']),
      correctIndex: json['correctIndex'] as int,
      subject:      subject,
      year:         json['year'] as int,
    );
  }
}

// ── Theory Question Model ─────────────────────────────────────────────────────
class TheoryQuestion {
  final String question;
  final String answer;
  final String subject;
  final int year;

  const TheoryQuestion({
    required this.question,
    required this.answer,
    required this.subject,
    required this.year,
  });

  factory TheoryQuestion.fromJson(Map<String, dynamic> json, String subject) {
    return TheoryQuestion(
      question: json['question'] as String,
      answer:   json['answer']   as String,
      subject:  subject,
      year:     json['year']     as int,
    );
  }
}

// ── Question Service ──────────────────────────────────────────────────────────
// Loads questions from JSON asset files.
// Each subject has its own JSON file in assets/questions/
// Call QuestionService.loadQuestions('mathematics') to get all Math questions.

class QuestionService {
  // Cache so JSON is only parsed once per session
  static final Map<String, List<Question>>       _objectiveCache = {};
  static final Map<String, List<TheoryQuestion>> _theoryCache    = {};

  // ── Load objective questions for a subject ──────────────────────────────
  static Future<List<Question>> loadQuestions(String subject) async {
    final key = subject.toLowerCase();

    if (_objectiveCache.containsKey(key)) {
      return _objectiveCache[key]!;
    }

    try {
      final String jsonString =
          await rootBundle.loadString('assets/questions/$key.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      final String subjectName = data['subject'] as String;
      final List<dynamic> rawList = data['questions'] as List<dynamic>;

      final questions = rawList
          .map((q) => Question.fromJson(q as Map<String, dynamic>, subjectName))
          .toList();

      _objectiveCache[key] = questions;
      return questions;
    } catch (e) {
      // Return empty list if file not found
      print('QuestionService: Could not load $key.json — $e');
      return [];
    }
  }

  // ── Load theory questions for a subject ────────────────────────────────
  static Future<List<TheoryQuestion>> loadTheoryQuestions(String subject) async {
    final key = '${subject.toLowerCase()}_theory';

    if (_theoryCache.containsKey(key)) {
      return _theoryCache[key]!;
    }

    try {
      final String jsonString =
          await rootBundle.loadString('assets/questions/${subject.toLowerCase()}_theory.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      final String subjectName = data['subject'] as String;
      final List<dynamic> rawList = data['questions'] as List<dynamic>;

      final questions = rawList
          .map((q) => TheoryQuestion.fromJson(q as Map<String, dynamic>, subjectName))
          .toList();

      _theoryCache[key] = questions;
      return questions;
    } catch (e) {
      print('QuestionService: Could not load ${subject.toLowerCase()}_theory.json — $e');
      return [];
    }
  }

  // ── Clear cache (call on low memory) ───────────────────────────────────
  static void clearCache() {
    _objectiveCache.clear();
    _theoryCache.clear();
  }
}

// ── Shuffle helpers ───────────────────────────────────────────────────────────
List<Question> shuffleQuestions(List<Question> questions) {
  final list = List<Question>.from(questions);
  list.shuffle(Random());
  return list;
}

List<Question> getRandomQuestions(List<Question> questions, {int count = 20}) {
  final shuffled = shuffleQuestions(questions);
  return shuffled.take(count).toList();
}

List<TheoryQuestion> shuffleTheoryQuestions(List<TheoryQuestion> questions) {
  final list = List<TheoryQuestion>.from(questions);
  list.shuffle(Random());
  return list;
}
// Temporary bridge — remove once all screens use QuestionService
const List<Question> sampleMathQuestions = [];