import 'package:flutter/material.dart';
import '../../../app/app_bottom_nav_bar.dart';
import '../../../core/database/database_service.dart';

// ── Data model for each slide ─────────────────────────────────────────────────
class _OnboardingSlide {
  final String title;
  final String subtitle;
  final String stat;
  final String statLabel;
  final String quote;
  final Color primaryColor;
  final Color accentColor;
  final IconData heroIcon;
  final List<_SubjectChip> chips;

  const _OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.stat,
    required this.statLabel,
    required this.quote,
    required this.primaryColor,
    required this.accentColor,
    required this.heroIcon,
    required this.chips,
  });
}

class _SubjectChip {
  final String label;
  final IconData icon;
  const _SubjectChip(this.label, this.icon);
}

const List<_OnboardingSlide> _slides = [
  _OnboardingSlide(
    title: 'Your SSCE Success\nStarts Here',
    subtitle: 'Join thousands of Nigerian students preparing smarter for WAEC & NECO with offline access — no data needed.',
    stat: '73%',
    statLabel: 'of students who practice past questions pass WAEC on their first attempt',
    quote: '"Preparation is the key that unlocks the door to success."',
    primaryColor: Color(0xFF2D4A8A),
    accentColor: Color(0xFFF5A623),
    heroIcon: Icons.emoji_events_rounded,
    chips: [
      _SubjectChip('Mathematics', Icons.calculate_rounded),
      _SubjectChip('Physics', Icons.bolt_rounded),
      _SubjectChip('Chemistry', Icons.science_rounded),
      _SubjectChip('Biology', Icons.eco_rounded),
    ],
  ),
  _OnboardingSlide(
    title: '10+ Years of Past\nQuestions, Offline',
    subtitle: 'Access WAEC & NECO past questions from 2010–2024 across all departments — Science, Art, and Commercial.',
    stat: '5,000+',
    statLabel: 'practice questions across all SSCE subjects, fully available offline',
    quote: '"The more you practice, the luckier you get."',
    primaryColor: Color(0xFF1A7A5E),
    accentColor: Color(0xFF4ECBA0),
    heroIcon: Icons.library_books_rounded,
    chips: [
      _SubjectChip('Science', Icons.biotech_rounded),
      _SubjectChip('Art', Icons.palette_rounded),
      _SubjectChip('Commercial', Icons.trending_up_rounded),
      _SubjectChip('English', Icons.menu_book_rounded),
    ],
  ),
  _OnboardingSlide(
    title: 'Track Every Step\nof Your Progress',
    subtitle: 'See your accuracy per subject, identify weak areas, and get smart insights to focus your revision where it matters most.',
    stat: '2×',
    statLabel: 'students who track their progress are twice as likely to improve their scores',
    quote: '"Know where you stand so you can go where you want."',
    primaryColor: Color(0xFF6C3D8A),
    accentColor: Color(0xFFB57BEA),
    heroIcon: Icons.insights_rounded,
    chips: [
      _SubjectChip('Accuracy', Icons.verified_rounded),
      _SubjectChip('Streaks', Icons.local_fire_department_rounded),
      _SubjectChip('Insights', Icons.lightbulb_rounded),
      _SubjectChip('Badges', Icons.workspace_premium_rounded),
    ],
  ),
  _OnboardingSlide(
    title: 'How SSCE\nPrep Pro Works',
    subtitle: 'Three simple steps to exam confidence — pick your subject, practice past questions, and watch your scores climb.',
    stat: '3',
    statLabel: 'simple steps: Choose subject → Practice questions → Track your progress',
    quote: '"Small daily improvements lead to stunning long-term results."',
    primaryColor: Color(0xFFB84A1A),
    accentColor: Color(0xFFF5A623),
    heroIcon: Icons.rocket_launch_rounded,
    chips: [
      _SubjectChip('Step 1: Choose', Icons.touch_app_rounded),
      _SubjectChip('Step 2: Practice', Icons.quiz_rounded),
      _SubjectChip('Step 3: Improve', Icons.trending_up_rounded),
      _SubjectChip('Repeat!', Icons.loop_rounded),
    ],
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnimation  = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    _fadeController.reset();
    _fadeController.forward();
  }

  void _next() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      _getStarted();
    }
  }

  void _skip() {
    _pageController.animateToPage(_slides.length - 1, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
  }

  // ── Mark onboarding done and navigate ─────────────────────────────────
  Future<void> _getStarted() async {
    await DatabaseService.setOnboardingDone();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AppBottomNavBar()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_currentPage];
    final isLast = _currentPage == _slides.length - 1;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: slide.primaryColor,
        child: SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Container(
                        width: 34, height: 34,
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 8),
                      const Text('SSCE Prep Pro', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                    ]),
                    if (!isLast)
                      TextButton(
                        onPressed: _skip,
                        child: const Text('Skip', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
                      ),
                  ],
                ),
              ),

              // Slides
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _slides.length,
                  itemBuilder: (context, index) => _SlideContent(slide: _slides[index], fadeAnimation: _fadeAnimation),
                ),
              ),

              // Bottom controls
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_slides.length, (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _currentPage ? 28 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _currentPage ? Colors.white : Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      )),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity, height: 54,
                      child: ElevatedButton(
                        onPressed: _next,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: slide.accentColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(isLast ? 'Get Started' : 'Next', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                            const SizedBox(width: 8),
                            Icon(isLast ? Icons.rocket_launch_rounded : Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                          ],
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

class _SlideContent extends StatelessWidget {
  final _OnboardingSlide slide;
  final Animation<double> fadeAnimation;

  const _SlideContent({required this.slide, required this.fadeAnimation});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 110, height: 110,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
                child: Icon(slide.heroIcon, color: Colors.white, size: 56),
              ),
            ),
            const SizedBox(height: 28),
            Text(slide.title, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white, height: 1.2)),
            const SizedBox(height: 14),
            Text(slide.subtitle, style: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0.85), height: 1.6)),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Text(slide.stat, style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: slide.accentColor)),
                  const SizedBox(width: 14),
                  Expanded(child: Text(slide.statLabel, style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.9), height: 1.5))),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10, runSpacing: 10,
              children: slide.chips.map((chip) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withOpacity(0.25)),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(chip.icon, color: slide.accentColor, size: 16),
                  const SizedBox(width: 6),
                  Text(chip.label, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                ]),
              )).toList(),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border(left: BorderSide(color: slide.accentColor, width: 4)),
              ),
              child: Text(slide.quote, style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Colors.white.withOpacity(0.9), height: 1.5)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}