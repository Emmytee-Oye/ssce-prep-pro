import 'package:flutter/material.dart';
import 'question_model.dart';
import 'quiz_screen.dart';
import '../../../core/database/database_service.dart';


class QuizResultScreen extends StatefulWidget {
  final String subject;
  final Color color;
  final List<Question> questions;
  final List<int> userAnswers;

  const QuizResultScreen({
    super.key,
    required this.subject,
    required this.color,
    required this.questions,
    required this.userAnswers,
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  @override
  void initState() {
    super.initState();
    _saveResult();
  }

  // ── Save result to Hive ───────────────────────────────────────────────
  Future<void> _saveResult() async {
    await DatabaseService.saveQuizResult(
      subject: widget.subject,
      correct: _correctCount,
      wrong:   _wrongCount,
      total:   widget.questions.length,
    );
  }

  int get _correctCount {
    int count = 0;
    for (int i = 0; i < widget.questions.length; i++) {
      if (i < widget.userAnswers.length && widget.userAnswers[i] == widget.questions[i].correctIndex) count++;
    }
    return count;
  }

  int get _wrongCount => widget.questions.length - _correctCount;
  double get _percentage => (_correctCount / widget.questions.length) * 100;

  String get _message {
    if (_percentage >= 80) return '🎉 Excellent! Keep it up!';
    if (_percentage >= 60) return '👍 Good job! Room to improve.';
    if (_percentage >= 40) return '📚 Keep practicing!';
    return '💪 Don\'t give up! Try again.';
  }

  Color get _scoreColor {
    if (_percentage >= 80) return const Color(0xFF38A169);
    if (_percentage >= 60) return const Color(0xFFF5A623);
    return const Color(0xFFE53E3E);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: widget.color,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('${widget.subject} • Results', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Score card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(color: _scoreColor.withOpacity(0.12), shape: BoxShape.circle),
                    child: Icon(_percentage >= 60 ? Icons.emoji_events_rounded : Icons.school_rounded, color: _scoreColor, size: 40),
                  ),
                  const SizedBox(height: 16),
                  const Text('Quiz Complete!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
                  const SizedBox(height: 6),
                  const Text('Here\'s your result', style: TextStyle(fontSize: 13, color: Color(0xFF9AA5B4))),
                  const SizedBox(height: 24),
                  Text('${_percentage.toStringAsFixed(0)}%', style: TextStyle(fontSize: 56, fontWeight: FontWeight.w900, color: _scoreColor)),
                  const Text('Overall Score', style: TextStyle(fontSize: 13, color: Color(0xFF9AA5B4))),
                  const SizedBox(height: 24),
                  _scoreRow(Icons.check_rounded, 'Correct Answers', '$_correctCount', const Color(0xFF38A169)),
                  const SizedBox(height: 10),
                  _scoreRow(Icons.close_rounded, 'Wrong Answers', '$_wrongCount', const Color(0xFFE53E3E)),
                  const SizedBox(height: 10),
                  _scoreRow(Icons.quiz_rounded, 'Total Questions', '${widget.questions.length}', const Color(0xFF2D4A8A)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Motivation
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _scoreColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _scoreColor.withOpacity(0.2)),
              ),
              child: Text(_message, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _scoreColor)),
            ),

            const SizedBox(height: 24),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Answer Review', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
            ),
            const SizedBox(height: 12),

            ...List.generate(widget.questions.length, (i) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ReviewCard(
                index: i,
                question: widget.questions[i],
                userAnswer: i < widget.userAnswers.length ? widget.userAnswers[i] : -1,
              ),
            )),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity, height: 54,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => QuizScreen(subject: widget.subject, color: widget.color, questions: widget.questions))),
                style: ElevatedButton.styleFrom(backgroundColor: widget.color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                label: const Text('Try Again', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity, height: 54,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                style: OutlinedButton.styleFrom(side: BorderSide(color: widget.color, width: 2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                icon: Icon(Icons.home_rounded, color: widget.color),
                label: Text('Back to Dashboard', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: widget.color)),
              ),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _scoreRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(width: 32, height: 32, decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 18)),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF4A5568)))),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
      ],
    );
  }
}

class _ReviewCard extends StatefulWidget {
  final int index;
  final Question question;
  final int userAnswer;

  const _ReviewCard({required this.index, required this.question, required this.userAnswer});

  @override
  State<_ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<_ReviewCard> {
  bool _expanded = false;
  bool get _isCorrect => widget.userAnswer == widget.question.correctIndex;

  @override
  Widget build(BuildContext context) {
    final statusColor = _isCorrect ? const Color(0xFF38A169) : const Color(0xFFE53E3E);

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: statusColor.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(7)),
                  child: Center(child: Text('${widget.index + 1}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: statusColor))),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(widget.question.question,
                    maxLines: _expanded ? null : 1,
                    overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E)),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(_isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded, color: statusColor, size: 20),
              ],
            ),
            if (_expanded) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFF38A169).withOpacity(0.08), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF38A169).withOpacity(0.2))),
                child: Row(children: [
                  const Icon(Icons.check_rounded, color: Color(0xFF38A169), size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text('Correct: ${widget.question.options[widget.question.correctIndex]}', style: const TextStyle(fontSize: 13, color: Color(0xFF38A169), fontWeight: FontWeight.w600))),
                ]),
              ),
              if (!_isCorrect) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFFE53E3E).withOpacity(0.08), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE53E3E).withOpacity(0.2))),
                  child: Row(children: [
                    const Icon(Icons.close_rounded, color: Color(0xFFE53E3E), size: 16),
                    const SizedBox(width: 8),
                    Expanded(child: Text(
                      widget.userAnswer == -1 ? 'Your answer: Not answered (time ran out)' : 'Your answer: ${widget.question.options[widget.userAnswer]}',
                      style: const TextStyle(fontSize: 13, color: Color(0xFFE53E3E), fontWeight: FontWeight.w600),
                    )),
                  ]),
                ),
              ],
            ],
            if (!_expanded)
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text('Tap to see answer', style: TextStyle(fontSize: 11, color: Color(0xFF9AA5B4))),
              ),
          ],
        ),
      ),
    );
  }
}