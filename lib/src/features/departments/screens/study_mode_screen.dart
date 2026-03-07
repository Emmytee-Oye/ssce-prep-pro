import 'package:flutter/material.dart';
import 'package:ssce_prep_pro/src/core/theme/app_theme.dart';
import 'package:ssce_prep_pro/src/features/quiz/screens/question_model.dart';
import 'package:ssce_prep_pro/src/features/quiz/screens/quiz_screen.dart';
import 'package:ssce_prep_pro/src/features/quiz/screens/objective_study_screen.dart';
import 'package:ssce_prep_pro/src/features/quiz/screens/theory_screen.dart';

class StudyModeScreen extends StatefulWidget {
  final String subject;
  final String department;
  final Color color;
  final IconData icon;

  const StudyModeScreen({
    super.key,
    required this.subject,
    required this.department,
    required this.color,
    required this.icon,
  });

  @override
  State<StudyModeScreen> createState() => _StudyModeScreenState();
}

class _StudyModeScreenState extends State<StudyModeScreen> {
  int _selectedYear = 2020; // ← default changed to 2020 (most questions here)
  bool _isLoading   = false;
  final List<int> _years = [2020, 2021, 2022, 2023, 2024, 2025];

  // Maps subject name to its JSON filename
  // e.g. "Mathematics" → "mathematics"
  // e.g. "English Language" → "english_language"
  String get _subjectKey =>
      widget.subject.toLowerCase().replaceAll(' ', '_');

  // ── Year picker bottom sheet ──────────────────────────────────────────
  void _showYearPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SizedBox(
        height: 300,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.textLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Exam Year',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _years.length,
                itemBuilder: (context, index) {
                  final year       = _years[index];
                  final isSelected = year == _selectedYear;
                  return ListTile(
                    title: Text(
                      year.toString(),
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                        color: isSelected ? widget.color : AppColors.textDark,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_circle_rounded, color: widget.color)
                        : null,
                    onTap: () {
                      setState(() => _selectedYear = year);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Objective Study: load from JSON, filter by year ───────────────────
  Future<void> _openObjectiveStudy() async {
     print('Looking for file: assets/questions/$_subjectKey.json'); 
    setState(() => _isLoading = true);
    try {
      final allQuestions = await QuestionService.loadQuestions(_subjectKey);

      // Filter to only show selected year's questions
      final yearQuestions = allQuestions
          .where((q) => q.year == _selectedYear)
          .toList();

      if (yearQuestions.isEmpty) {
        _showNoQuestionsSnackbar();
        return;
      }

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ObjectiveStudyScreen(
            subject:   widget.subject,
            color:     widget.color,
            year:      _selectedYear,
            questions: yearQuestions,
          ),
        ),
      );
    } catch (e) {
      _showErrorSnackbar();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Theory Study: load from JSON, shuffle ─────────────────────────────
  Future<void> _openTheoryStudy() async {
    setState(() => _isLoading = true);
    try {
      final questions =
          await QuestionService.loadTheoryQuestions(_subjectKey);

      if (questions.isEmpty) {
        _showNoQuestionsSnackbar();
        return;
      }

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TheoryScreen(
            subject:   widget.subject,
            color:     widget.color,
            questions: shuffleTheoryQuestions(questions),
          ),
        ),
      );
    } catch (e) {
      _showErrorSnackbar();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Quiz: load from JSON, pick 20 random from ALL years ───────────────
  Future<void> _openQuiz() async {
    setState(() => _isLoading = true);
    try {
      final allQuestions = await QuestionService.loadQuestions(_subjectKey);

      if (allQuestions.isEmpty) {
        _showNoQuestionsSnackbar();
        return;
      }

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuizScreen(
            subject:   widget.subject,
            color:     widget.color,
            questions: getRandomQuestions(allQuestions, count: 20),
          ),
        ),
      );
    } catch (e) {
      _showErrorSnackbar();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showNoQuestionsSnackbar() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'No questions found for ${widget.subject} $_selectedYear yet. Try another year or check back soon!',
        ),
        backgroundColor: const Color(0xFFF5A623),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showErrorSnackbar() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Could not load ${widget.subject} questions. Make sure ${_subjectKey}.json is in assets/questions/',
        ),
        backgroundColor: const Color(0xFFE53E3E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.subject),
            const Text(
              'Choose study mode',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: widget.color,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: widget.color),
                  const SizedBox(height: 16),
                  const Text(
                    'Loading questions...',
                    style: TextStyle(fontSize: 14, color: AppColors.textLight),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Year picker ──────────────────────────────────────
                  const Text(
                    'Select Exam Year',
                    style: TextStyle(fontSize: 13, color: AppColors.textLight, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _showYearPicker,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.textLight.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month_rounded, color: widget.color, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            '$_selectedYear',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Change',
                            style: TextStyle(
                              fontSize: 13,
                              color: widget.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Study Options',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Objective and Theory are for self-study. Quiz is for timed practice.',
                    style: TextStyle(fontSize: 12, color: AppColors.textLight, height: 1.4),
                  ),
                  const SizedBox(height: 16),

                  // ── Objective Study ──────────────────────────────────
                  _ModeCard(
                    icon:       Icons.menu_book_rounded,
                    color:      widget.color,
                    title:      'Past Questions (Objective)',
                    subtitle:   'Read $_selectedYear questions with options A–D. Answers listed at the bottom.',
                    badge:      'Study Mode',
                    badgeColor: widget.color,
                    onTap:      _openObjectiveStudy,
                  ),
                  const SizedBox(height: 12),

                  // ── Theory Study ─────────────────────────────────────
                  _ModeCard(
                    icon:       Icons.edit_note_rounded,
                    color:      const Color(0xFF1A7A5E),
                    title:      'Past Questions (Theory)',
                    subtitle:   'Read essay questions and reveal model answers.',
                    badge:      'Study Mode',
                    badgeColor: const Color(0xFF1A7A5E),
                    onTap:      _openTheoryStudy,
                  ),
                  const SizedBox(height: 12),

                  // ── Timed Quiz ───────────────────────────────────────
                  _ModeCard(
                    icon:       Icons.bolt_rounded,
                    color:      const Color(0xFFB84A1A),
                    title:      'Quick Quiz (Timed)',
                    subtitle:   '20 random questions • 30s per question • 15 mins total.',
                    badge:      'Quiz Mode',
                    badgeColor: const Color(0xFFB84A1A),
                    onTap:      _openQuiz,
                  ),

                  const SizedBox(height: 28),

                  // ── Stats card ───────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: widget.color.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Icon(Icons.bar_chart_rounded, color: widget.color, size: 18),
                          const SizedBox(width: 8),
                          const Text(
                            'Your Stats',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark),
                          ),
                        ]),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _StatItem(value: '0',  label: 'Questions\nSolved', color: widget.color),
                            _StatItem(value: '0%', label: 'Accuracy',          color: widget.color),
                            _StatItem(value: '0',  label: 'Quizzes\nTaken',    color: widget.color),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}

// ── Mode Card widget ──────────────────────────────────────────────────────────
class _ModeCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String badge;
  final Color badgeColor;
  final VoidCallback onTap;

  const _ModeCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Flexible(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badge,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: badgeColor,
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textLight, size: 20),
          ],
        ),
      ),
    );
  }
}

// ── Stat item widget ──────────────────────────────────────────────────────────
class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textLight,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}