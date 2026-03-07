import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'select_subject_screen.dart';

class DepartmentsScreen extends StatelessWidget {
  const DepartmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ─────────────────────────────────────────────
              const Text(
                'Choose Your\nDepartment',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Select your field of study',
                style: TextStyle(fontSize: 14, color: AppColors.textLight),
              ),

              const SizedBox(height: 28),

              // ── Department cards ────────────────────────────────────
              _DepartmentCard(
                icon: Icons.science_rounded,
                color: AppColors.primary,
                name: 'Science',
                subjects: 'Math, Physics, Chemistry, Biology',
                subjectCount: 4,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SelectSubjectScreen(
                      department: 'Science',
                      color: AppColors.primary,
                      icon: Icons.science_rounded,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              _DepartmentCard(
                icon: Icons.palette_rounded,
                color: Color(0xFFE91E8C),
                name: 'Art',
                subjects: 'English, Literature, Government, CRS/IRS',
                subjectCount: 4,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SelectSubjectScreen(
                      department: 'Art',
                      color: Color(0xFFE91E8C),
                      icon: Icons.palette_rounded,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              _DepartmentCard(
                icon: Icons.trending_up_rounded,
                color: AppColors.success,
                name: 'Commercial',
                subjects: 'Economics, Commerce, Accounting',
                subjectCount: 3,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SelectSubjectScreen(
                      department: 'Commercial',
                      color: AppColors.success,
                      icon: Icons.trending_up_rounded,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── Tip card ────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                ),
                child: Row(
                  children: const [
                    Text('💡', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Tip: You can switch departments anytime from the home screen.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textMedium,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Department card ───────────────────────────────────────────────────────────
class _DepartmentCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String name;
  final String subjects;
  final int subjectCount;
  final VoidCallback onTap;

  const _DepartmentCard({
    required this.icon,
    required this.color,
    required this.name,
    required this.subjects,
    required this.subjectCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subjects,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '$subjectCount subjects',
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
            Icon(Icons.chevron_right_rounded,
                color: AppColors.textLight, size: 22),
          ],
        ),
      ),
    );
  }
}