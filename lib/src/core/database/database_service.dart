import 'package:hive/hive.dart';

// ── Constants ─────────────────────────────────────────────────────────────────
const String quizResultsBox = 'quiz_results';
const String settingsBox    = 'settings';
const String onboardingKey  = 'onboarding_done';

// ── Database Service ──────────────────────────────────────────────────────────
class DatabaseService {

  // Save a quiz result as a simple map
  static Future<void> saveQuizResult({
    required String subject,
    required int correct,
    required int wrong,
    required int total,
  }) async {
    final box = Hive.box(quizResultsBox);
    await box.add({
      'subject':  subject,
      'correct':  correct,
      'wrong':    wrong,
      'total':    total,
      'accuracy': total > 0 ? correct / total : 0.0,
      'date':     DateTime.now().toIso8601String(),
    });
  }

  // Get all results
  static List<Map> getAllResults() {
    final box = Hive.box(quizResultsBox);
    final results = box.values.map((e) => Map.from(e as Map)).toList();
    results.sort((a, b) {
      final dateA = DateTime.parse(a['date'] as String);
      final dateB = DateTime.parse(b['date'] as String);
      return dateB.compareTo(dateA);
    });
    return results;
  }

  // Get overall stats
  static Map<String, dynamic> getOverallStats() {
    final results = getAllResults();
    if (results.isEmpty) {
      return {'totalQuestions': 0, 'accuracy': 0.0, 'quizzesTaken': 0};
    }
    int totalQuestions = 0;
    int totalCorrect   = 0;
    for (final r in results) {
      totalQuestions += r['total'] as int;
      totalCorrect   += r['correct'] as int;
    }
    final accuracy = totalQuestions > 0 ? (totalCorrect / totalQuestions) * 100 : 0.0;
    return {
      'totalQuestions': totalQuestions,
      'accuracy':       accuracy,
      'quizzesTaken':   results.length,
    };
  }

  // Onboarding
  static bool isOnboardingDone() {
    final box = Hive.box(settingsBox);
    return box.get(onboardingKey, defaultValue: false) as bool;
  }

  static Future<void> setOnboardingDone() async {
    final box = Hive.box(settingsBox);
    await box.put(onboardingKey, true);
  }

  // Clear all data
  static Future<void> clearAll() async {
    await Hive.box(quizResultsBox).clear();
  }
}