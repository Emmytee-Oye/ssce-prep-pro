import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/database_service.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int)? onTabChange;
  const HomeScreen({super.key, this.onTabChange});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> _stats = {};
  List<Map> _recentResults = [];
  int _selectedDept = 0;

  final List<Map<String, dynamic>> _departments = [
    {'label': 'Science',    'icon': Icons.science_rounded,      'color': AppColors.primary},
    {'label': 'Art',        'icon': Icons.palette_rounded,       'color': Color(0xFFE91E8C)},
    {'label': 'Commercial', 'icon': Icons.trending_up_rounded,   'color': AppColors.success},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _stats         = DatabaseService.getOverallStats();
      _recentResults = DatabaseService.getAllResults().take(3).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalQuestions = _stats['totalQuestions'] ?? 0;
    final accuracy       = (_stats['accuracy'] ?? 0.0) as double;
    final quizzesTaken   = _stats['quizzesTaken'] ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('SSCE Prep Pro'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none_rounded), onPressed: () {}),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Header ──────────────────────────────────────
              const Text('Ready to prepare? 👋', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textDark)),
              const SizedBox(height: 4),
              const Text('Keep practicing to improve your score!', style: TextStyle(fontSize: 13, color: AppColors.textLight)),
              const SizedBox(height: 20),

              // ── Stats card ───────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF2D4A8A), Color(0xFF3D5FA0)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6))],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                      child: const Text('🎯 Overall Performance', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _statCol('$totalQuestions', 'Questions\nSolved', const Color(0xFFF5A623)),
                        Container(width: 1, height: 40, color: Colors.white.withOpacity(0.2)),
                        _statCol('${accuracy.toStringAsFixed(0)}%', 'Accuracy', const Color(0xFF4ECBA0)),
                        Container(width: 1, height: 40, color: Colors.white.withOpacity(0.2)),
                        _statCol('$quizzesTaken', 'Quizzes\nTaken', const Color(0xFFB57BEA)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Department switcher ──────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Your Department', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  GestureDetector(
                    onTap: () => widget.onTabChange?.call(1),
                    child: const Text('View All', style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: List.generate(_departments.length, (i) {
                  final dept     = _departments[i];
                  final selected = _selectedDept == i;
                  final color    = dept['color'] as Color;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: i < _departments.length - 1 ? 10 : 0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedDept = i);
                          // Navigate to Subjects tab after short delay
                          Future.delayed(const Duration(milliseconds: 200), () {
                            widget.onTabChange?.call(1);
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: selected ? color : AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))],
                          ),
                          child: Column(
                            children: [
                              Icon(dept['icon'] as IconData, size: 20, color: selected ? Colors.white : AppColors.textMedium),
                              const SizedBox(height: 4),
                              Text(dept['label'] as String, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: selected ? Colors.white : AppColors.textMedium)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 24),

              // ── Study options ────────────────────────────────
              const Text('Study Options', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
              const SizedBox(height: 12),
              _studyCard(Icons.description_rounded, AppColors.primary, 'Past Questions (Objective)', 'Practice multiple choice questions', 'Popular'),
              const SizedBox(height: 12),
              _studyCard(Icons.edit_note_rounded, const Color(0xFF1A7A5E), 'Past Questions (Theory)', 'Review essay questions with answers', 'New'),
              const SizedBox(height: 12),
              _studyCard(Icons.bolt_rounded, const Color(0xFFB84A1A), 'Quick Quiz (Random)', 'Test yourself with 20 random questions', 'Quick'),

              const SizedBox(height: 24),

              // ── Recent activity ──────────────────────────────
              const Text('Recent Activity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
              const SizedBox(height: 12),

              if (_recentResults.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      Icon(Icons.quiz_rounded, color: AppColors.textLight, size: 40),
                      const SizedBox(height: 12),
                      const Text('No quizzes taken yet', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark)),
                      const SizedBox(height: 4),
                      const Text('Complete a quiz to see your activity here.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: AppColors.textLight)),
                    ],
                  ),
                )
              else
                Column(
                  children: _recentResults.map((result) {
                    final subject = result['subject'] as String;
                    final correct = result['correct'] as int;
                    final total   = result['total'] as int;
                    final acc     = total > 0 ? (correct / total) * 100 : 0.0;
                    final isGood  = acc >= 60;
                    final color   = isGood ? AppColors.success : AppColors.warning;
                    final date    = DateTime.parse(result['date'] as String);
                    final timeAgo = _timeAgo(date);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38, height: 38,
                              decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                              child: Icon(isGood ? Icons.emoji_events_rounded : Icons.refresh_rounded, color: color, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(subject, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                                  Text(timeAgo, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                              child: Text('${acc.toStringAsFixed(0)}%', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCol(String value, String label, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 4),
        Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: Colors.white70, height: 1.3)),
      ],
    );
  }

  Widget _studyCard(IconData icon, Color color, String title, String subtitle, String tag) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 24)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Flexible(child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark))),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                    child: Text(tag, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
                  ),
                ]),
                const SizedBox(height: 3),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textLight, size: 20),
        ],
      ),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24)   return '${diff.inHours} hours ago';
    if (diff.inDays == 1)    return 'Yesterday';
    return '${diff.inDays} days ago';
  }
}