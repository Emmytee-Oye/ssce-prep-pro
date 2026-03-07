import 'package:flutter/material.dart';
import 'quiz_subject_picker_screen.dart';
import 'quiz_screen.dart';
import 'question_model.dart';

class QuizTabScreen extends StatelessWidget {
  const QuizTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text('Quick Quiz'),
        backgroundColor: const Color(0xFF2D4A8A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF2D4A8A).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.bolt_rounded, color: Color(0xFF2D4A8A), size: 50),
            ),
            const SizedBox(height: 24),
            const Text('Quick Quiz', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
            const SizedBox(height: 10),
            const Text(
              'Choose a subject and test your knowledge with 20 questions.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF9AA5B4), height: 1.6),
            ),
            const SizedBox(height: 36),

            // Pick subject button
            SizedBox(
              width: double.infinity, height: 54,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QuizSubjectPickerScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D4A8A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.menu_book_rounded, color: Colors.white),
                label: const Text('Pick a Subject', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 14),

            // Random quiz button
            SizedBox(
              width: double.infinity, height: 54,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizScreen(
                        subject:   'Mathematics',
                        color:     const Color(0xFF2D4A8A),
                        questions: const [],
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF2D4A8A), width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.shuffle_rounded, color: Color(0xFF2D4A8A)),
                label: const Text('Random Quiz', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF2D4A8A))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}