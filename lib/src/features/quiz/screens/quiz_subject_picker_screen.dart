import 'package:flutter/material.dart';
import 'quiz_screen.dart';
import 'question_model.dart';

const Map<String, List<Map<String, dynamic>>> _departmentSubjects = {
  'Science': [
    {'name': 'Mathematics', 'icon': Icons.calculate_rounded,       'color': Color(0xFF6C63FF)},
    {'name': 'Physics',     'icon': Icons.bolt_rounded,            'color': Color(0xFF3182CE)},
    {'name': 'Chemistry',   'icon': Icons.science_rounded,         'color': Color(0xFF38A169)},
    {'name': 'Biology',     'icon': Icons.eco_rounded,             'color': Color(0xFFE53E3E)},
  ],
  'Art': [
    {'name': 'English Language', 'icon': Icons.menu_book_rounded,       'color': Color(0xFFE91E8C)},
    {'name': 'Literature',       'icon': Icons.auto_stories_rounded,    'color': Color(0xFF9C27B0)},
    {'name': 'Government',       'icon': Icons.account_balance_rounded, 'color': Color(0xFF3182CE)},
    {'name': 'CRS',              'icon': Icons.church_rounded,          'color': Color(0xFFF5A623)},
    {'name': 'IRS',              'icon': Icons.mosque_rounded,          'color': Color(0xFF38A169)},
  ],
  'Commercial': [
    {'name': 'Economics',  'icon': Icons.bar_chart_rounded,        'color': Color(0xFF38A169)},
    {'name': 'Commerce',   'icon': Icons.store_rounded,            'color': Color(0xFF3182CE)},
    {'name': 'Accounting', 'icon': Icons.calculate_rounded,        'color': Color(0xFFB84A1A)},
  ],
};

class QuizSubjectPickerScreen extends StatefulWidget {
  const QuizSubjectPickerScreen({super.key});

  @override
  State<QuizSubjectPickerScreen> createState() =>
      _QuizSubjectPickerScreenState();
}

class _QuizSubjectPickerScreenState extends State<QuizSubjectPickerScreen> {
  String _selectedDept = 'Science';
  // Track which subject is currently loading
  String? _loadingSubject;

  final List<String> _departments = ['Science', 'Art', 'Commercial'];

  // ── Load questions from JSON then open QuizScreen ─────────────────────
  Future<void> _startQuiz(String subjectName, Color color) async {
    if (_loadingSubject != null) return; // prevent double tap

    setState(() => _loadingSubject = subjectName);

    try {
      // Convert subject name to JSON filename key
      // e.g. "English Language" → "english_language"
      final key = subjectName.toLowerCase().replaceAll(' ', '_');

      final allQuestions = await QuestionService.loadQuestions(key);

      if (allQuestions.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No questions found for $subjectName. '
              'Make sure ${key}.json is in assets/questions/',
            ),
            backgroundColor: const Color(0xFFE53E3E),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        return;
      }

      final picked = getRandomQuestions(allQuestions, count: 20);

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuizScreen(
            subject:   subjectName,
            color:     color,
            questions: picked,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading $subjectName questions: $e'),
          backgroundColor: const Color(0xFFE53E3E),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } finally {
      if (mounted) setState(() => _loadingSubject = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final subjects = _departmentSubjects[_selectedDept] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text('Choose Subject'),
        backgroundColor: const Color(0xFF2D4A8A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Department tabs ───────────────────────────────
          Container(
            color: const Color(0xFF2D4A8A),
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Row(
              children: _departments.map((dept) {
                final isSelected = dept == _selectedDept;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: dept != _departments.last ? 8 : 0),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedDept = dept),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white
                              : Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          dept,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? const Color(0xFF2D4A8A)
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // ── Subjects list ─────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_selectedDept Subjects',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E)),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Select a subject to start your quiz',
                    style:
                        TextStyle(fontSize: 13, color: Color(0xFF9AA5B4)),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: subjects.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final subject = subjects[index];
                        final color   = subject['color'] as Color;
                        final name    = subject['name'] as String;
                        final isLoading = _loadingSubject == name;

                        return InkWell(
                          onTap: isLoading
                              ? null
                              : () => _startQuiz(name, color),
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        Colors.black.withOpacity(0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2))
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                      color: color.withOpacity(0.12),
                                      borderRadius:
                                          BorderRadius.circular(12)),
                                  child: Icon(
                                      subject['icon'] as IconData,
                                      color: color,
                                      size: 24),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF1A1A2E)),
                                      ),
                                      const SizedBox(height: 3),
                                      const Text(
                                        '20 questions • 30s per question',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF9AA5B4)),
                                      ),
                                    ],
                                  ),
                                ),
                                // Start button / loading indicator
                                isLoading
                                    ? SizedBox(
                                        width: 36,
                                        height: 36,
                                        child: CircularProgressIndicator(
                                          color: color,
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                            color: color,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: const Text('Start',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white)),
                                      ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}