import 'package:flutter/material.dart';
import '../../../core/database/database_service.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  Map<String, dynamic> _overallStats = {};
  List<Map> _recentResults = [];
  bool _hasData = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final stats   = DatabaseService.getOverallStats();
    final results = DatabaseService.getAllResults();
    setState(() {
      _overallStats  = stats;
      _recentResults = results.take(5).toList();
      _hasData       = results.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalQuestions = _overallStats['totalQuestions'] ?? 0;
    final accuracy       = (_overallStats['accuracy'] ?? 0.0) as double;
    final quizzesTaken   = _overallStats['quizzesTaken'] ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text('Your Progress'),
        backgroundColor: const Color(0xFF2D4A8A),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadData,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Overall card ────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2D4A8A), Color(0xFF3D5FA0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: const Color(0xFF2D4A8A).withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.workspace_premium_rounded, color: Color(0xFFF5A623), size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Overall Performance', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                        Text('All subjects combined', style: TextStyle(color: Colors.white60, fontSize: 12)),
                      ],
                    ),
                  ]),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statCol('$totalQuestions', 'Questions', const Color(0xFFF5A623)),
                      Container(width: 1, height: 40, color: Colors.white.withOpacity(0.2)),
                      _statCol('${accuracy.toStringAsFixed(0)}%', 'Accuracy', const Color(0xFF4ECBA0)),
                      Container(width: 1, height: 40, color: Colors.white.withOpacity(0.2)),
                      _statCol('$quizzesTaken', 'Quizzes', const Color(0xFFB57BEA)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Recent activity ──────────────────────────────────
            const Text('Recent Activity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
            const SizedBox(height: 12),

            if (!_hasData)
              _buildEmptyState()
            else
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Column(
                  children: List.generate(_recentResults.length, (i) {
                    final result  = _recentResults[i];
                    final subject = result['subject'] as String;
                    final correct = result['correct'] as int;
                    final total   = result['total'] as int;
                    final acc     = total > 0 ? (correct / total) * 100 : 0.0;
                    final isGood  = acc >= 60;
                    final color   = isGood ? const Color(0xFF38A169) : const Color(0xFFF5A623);
                    final date    = DateTime.parse(result['date'] as String);
                    final timeAgo = _timeAgo(date);

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                                    Text(subject, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
                                    Text(timeAgo, style: const TextStyle(fontSize: 11, color: Color(0xFF9AA5B4))),
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
                        if (i < _recentResults.length - 1) const Divider(height: 1, indent: 16, endIndent: 16),
                      ],
                    );
                  }),
                ),
              ),

            const SizedBox(height: 24),

            // ── Insights ─────────────────────────────────────────
            if (_hasData) ...[
              const Text('Insights', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
              const SizedBox(height: 12),
              _buildInsights(),
              const SizedBox(height: 24),
            ],

            // ── Keep going banner ─────────────────────────────────
            _buildKeepGoingBanner(quizzesTaken),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.bar_chart_rounded, color: Colors.grey.shade300, size: 56),
          const SizedBox(height: 16),
          const Text('No quiz data yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
          const SizedBox(height: 6),
          const Text(
            'Complete a quiz to see your progress here.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Color(0xFF9AA5B4)),
          ),
        ],
      ),
    );
  }

  Widget _buildInsights() {
    final results = DatabaseService.getAllResults();
    if (results.isEmpty) return const SizedBox.shrink();

    // Group by subject
    final Map<String, List<double>> subjectAccuracy = {};
    for (final r in results) {
      final subject = r['subject'] as String;
      final total   = r['total'] as int;
      final correct = r['correct'] as int;
      final acc     = total > 0 ? (correct / total) * 100 : 0.0;
      subjectAccuracy.putIfAbsent(subject, () => []).add(acc);
    }

    // Find best and worst subject
    String bestSubject  = '';
    String worstSubject = '';
    double bestAcc      = 0;
    double worstAcc     = 101;

    subjectAccuracy.forEach((subject, accs) {
      final avg = accs.reduce((a, b) => a + b) / accs.length;
      if (avg > bestAcc)  { bestAcc = avg;  bestSubject  = subject; }
      if (avg < worstAcc) { worstAcc = avg; worstSubject = subject; }
    });

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF38A169).withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF38A169).withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(children: [
                  Icon(Icons.trending_up_rounded, color: Color(0xFF38A169), size: 18),
                  SizedBox(width: 6),
                  Text('Strength', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF38A169))),
                ]),
                const SizedBox(height: 10),
                Text(bestSubject.isEmpty ? 'N/A' : bestSubject, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
                const SizedBox(height: 4),
                Text('${bestAcc.toStringAsFixed(0)}% accuracy', style: const TextStyle(fontSize: 12, color: Color(0xFF9AA5B4))),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5A623).withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFF5A623).withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(children: [
                  Icon(Icons.adjust_rounded, color: Color(0xFFF5A623), size: 18),
                  SizedBox(width: 6),
                  Text('Focus Area', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFF5A623))),
                ]),
                const SizedBox(height: 10),
                Text(worstSubject.isEmpty ? 'N/A' : worstSubject, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
                const SizedBox(height: 4),
                Text('${worstAcc.toStringAsFixed(0)}% accuracy', style: const TextStyle(fontSize: 12, color: Color(0xFF9AA5B4))),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKeepGoingBanner(int quizzesTaken) {
    final remaining = quizzesTaken < 3 ? 3 - quizzesTaken : 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFB84A1A), Color(0xFFE05A20)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
            child: const Icon(Icons.local_fire_department_rounded, color: Color(0xFFF5A623), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Keep Going!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 3),
                Text(
                  remaining > 0
                      ? 'Complete $remaining more ${remaining == 1 ? 'quiz' : 'quizzes'} to unlock achievement badges.'
                      : '🎉 You\'ve unlocked achievement badges! Keep practicing!',
                  style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCol(String value, String label, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
      ],
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60)  return '${diff.inMinutes} min ago';
    if (diff.inHours < 24)    return '${diff.inHours} hours ago';
    if (diff.inDays == 1)     return 'Yesterday';
    return '${diff.inDays} days ago';
  }
}