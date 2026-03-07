import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'study_mode_screen.dart';

// ── Subject data ──────────────────────────────────────────────────────────────
const Map<String, List<Map<String, dynamic>>> _departmentSubjects = {
  'Science': [
    {'name': 'Mathematics',   'icon': Icons.calculate_rounded,       'color': Color(0xFF6C63FF)},
    {'name': 'Physics',       'icon': Icons.bolt_rounded,            'color': Color(0xFF3182CE)},
    {'name': 'Chemistry',     'icon': Icons.science_rounded,         'color': Color(0xFF38A169)},
    {'name': 'Biology',       'icon': Icons.eco_rounded,             'color': Color(0xFFE53E3E)},
  ],
  'Art': [
    {'name': 'English Language', 'icon': Icons.menu_book_rounded,    'color': Color(0xFFE91E8C)},
    {'name': 'Literature',       'icon': Icons.auto_stories_rounded, 'color': Color(0xFF9C27B0)},
    {'name': 'Government',       'icon': Icons.account_balance_rounded,'color': Color(0xFF3182CE)},
    {'name': 'CRS',              'icon': Icons.church_rounded,       'color': Color(0xFFF5A623)},
    {'name': 'IRS',              'icon': Icons.mosque_rounded,       'color': Color(0xFF38A169)},
  ],
  'Commercial': [
    {'name': 'Economics',    'icon': Icons.bar_chart_rounded,        'color': Color(0xFF38A169)},
    {'name': 'Commerce',     'icon': Icons.store_rounded,            'color': Color(0xFF3182CE)},
    {'name': 'Accounting',   'icon': Icons.calculate_rounded,        'color': Color(0xFFB84A1A)},
  ],
};

const Map<String, List<String>> _popularSubjects = {
  'Science':    ['Mathematics', 'Physics'],
  'Art':        ['English Language', 'Literature'],
  'Commercial': ['Economics', 'Accounting'],
};

class SelectSubjectScreen extends StatelessWidget {
  final String department;
  final Color color;
  final IconData icon;

  const SelectSubjectScreen({
    super.key,
    required this.department,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final subjects = _departmentSubjects[department] ?? [];
    final popular  = _popularSubjects[department]   ?? [];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Subject'),
            Text(
              '$department Department',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Department badge ──────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: color, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    '$department Subjects',
                    style: TextStyle(
                      color: color,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Available subjects ────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${subjects.length} Available Subjects',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                Icon(Icons.keyboard_arrow_up_rounded, color: AppColors.textLight),
              ],
            ),

            const SizedBox(height: 12),

            // ── Subject list ──────────────────────────────────
            ...subjects.map((subject) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _SubjectTile(
                name:  subject['name'],
                icon:  subject['icon'],
                color: subject['color'],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StudyModeScreen(
                      subject:    subject['name'],
                      department: department,
                      color:      subject['color'],
                      icon:       subject['icon'],
                    ),
                  ),
                ),
              ),
            )),

            const SizedBox(height: 24),

            // ── Popular choices ───────────────────────────────
            Row(
              children: const [
                Text('🔥', style: TextStyle(fontSize: 16)),
                SizedBox(width: 6),
                Text(
                  'Popular Choices',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            ...popular.map((name) {
              final subject = subjects.firstWhere(
                (s) => s['name'] == name,
                orElse: () => subjects.first,
              );
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _PopularTile(
                  name:  name,
                  color: subject['color'],
                  icon:  subject['icon'],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StudyModeScreen(
                        subject:    name,
                        department: department,
                        color:      subject['color'],
                        icon:       subject['icon'],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ── Subject tile ──────────────────────────────────────────────────────────────
class _SubjectTile extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SubjectTile({
    required this.name,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.textLight, size: 20),
          ],
        ),
      ),
    );
  }
}

// ── Popular tile ──────────────────────────────────────────────────────────────
class _PopularTile extends StatelessWidget {
  final String name;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _PopularTile({
    required this.name,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Trending',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}